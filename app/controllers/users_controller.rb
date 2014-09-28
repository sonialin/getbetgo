class UsersController < ApplicationController
	before_action :set_user

  POSTS_PER_PAGE = 12

  def show
    @title = @user.name
    @posts = @user.posts.paginate(page: params[:page], per_page: POSTS_PER_PAGE).order("updated_at desc")
    @page = 1
    @user_posts = true
    @user_info = @user.user_info
    
    @relationship = Relationship.where(
      follower_id: current_user.id,
      followed_id: @user.id
      ).first_or_initialize if current_user

    respond_to do |format|
      format.html
      format.js { render '/posts/index.js.erb' }
    end
  end

  def followings
    @title = @user.name
    @users = @user.followeds.paginate(page: params[:page], per_page: 12)
  end

  def followers
    @title = @user.name
    @users = @user.followers.paginate(page: params[:page], per_page: 12)
  end

	private
		def set_user
      @user = User.find_by_identifier(params[:identifier])
    end
end
