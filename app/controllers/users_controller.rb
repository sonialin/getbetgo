class UsersController < ApplicationController
	before_action :set_user, only: [:show]

  def show
    @posts = @user.posts.paginate(page: params[:page], per_page: 12).order("updated_at desc")

    @user_posts = true

    respond_to do |format|
      format.html
      format.js { render '/posts/index.js.erb' }
    end
  end

	private
		def set_user
      @user = User.find(params[:id])
    end
end
