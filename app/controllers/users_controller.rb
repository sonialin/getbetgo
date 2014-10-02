class UsersController < ApplicationController
	before_action :set_user

  POSTS_PER_PAGE = 12

  def show
    @title = @user.name
    es_api = Posts::ElasticsearchApi.new
    es_query = es_api.build_es_query({funder_id: @user.id})
    page = (params[:page] || 1).to_i
    es_query = es_api.add_from_or_size(es_query, (page-1)*POSTS_PER_PAGE, POSTS_PER_PAGE)
    @posts = es_api.search(es_query)
    @next_page = es_api.get_count(es_query) > page*POSTS_PER_PAGE
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
