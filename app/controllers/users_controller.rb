class UsersController < ApplicationController
	before_action :set_user, only: [:show]

  def show
    @posts = @user.posts

    @paypal_recipient_accounts = @user.paypal_recipient_accounts
    @paypal_recipient_account = PaypalRecipientAccount.new

    @bets = @user.bets

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @user }
    end
  end

	private
		def set_user
      @user = User.find(params[:id])
    end
end
