class UsersController < ApplicationController
	before_action :set_user, only: [:show]

  def show
    @user_posts = true

    @user_info = @user.user_info

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
