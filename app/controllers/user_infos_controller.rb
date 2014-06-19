class UserInfosController < ApplicationController
	before_filter :authenticate_user!, only: [:create, :edit, :update]

  def create
  	@user = current_user
  	@user_info = UserInfo.create(user_info_params)
  	@user_info.user = @user

  	if @user_info.save
    	flash[:notice] = "Your info has been saved!"
    else
    	flash[:notice] = "Fail."
    end
    redirect_to :back
  end

  def edit
  	@user_info = current_user.user_info
  end

  def update
  	@user_info = current_user.user_info
    respond_to do |format|
      if @user_info.update(user_info_params)
        format.html { redirect_to @user_info.user, notice: 'Your info was successfully updated!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user_info.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_info_params
    	params.require(:user_info).permit(:biography)
    end
end
