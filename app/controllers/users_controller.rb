class UsersController < ApplicationController
	before_action :set_user

  def show
    @posts = @user.posts.paginate(page: params[:page], per_page: 12).order("updated_at desc")
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
    @users = @user.followeds
  end

  def followers
    @users = @user.followers
  end

	private
		def set_user
      @user = User.find(params[:id])
    end
end
