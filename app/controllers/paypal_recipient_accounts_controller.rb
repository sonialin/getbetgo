class PaypalRecipientAccountsController < ApplicationController
	before_filter :authenticate_user!

  def create
  	@paypal_recipient_account = current_user.paypal_recipient_accounts.new(paypal_recipient_accounts_params)

  	if @paypal_recipient_account.save
    	flash[:notice] = "Your account has been saved!"
    	redirect_to :controller => :users, :id => current_user.id, :action => :show
    else
    	flash[:notice] = "Fail."
    	redirect_to :controller => :users, :id => current_user.id, :action => :show
    end
  end

  def delete
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def paypal_recipient_accounts_params
    	params.require(:paypal_recipient_account).permit(:email)
    end
end
