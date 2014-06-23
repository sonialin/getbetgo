class PaypalRecipientAccountsController < ApplicationController
	before_filter :authenticate_user!

  def create
  	@paypal_recipient_account = current_user.create_paypal_recipient_account(paypal_recipient_accounts_params)

  	if @paypal_recipient_account.save
    	flash[:notice] = "Your account has been saved!"
    	redirect_to :controller => :users, :id => current_user.id, :action => :show
    else
    	flash[:notice] = "Oops - something went wrong. Please try again."
    	redirect_to :controller => :users, :id => current_user.id, :action => :show
    end
  end

  def destroy
  	@paypal_recipient_account = current_user.paypal_recipient_account
    @paypal_recipient_account.destroy
    respond_to do |format|
      format.html { redirect_to current_user, notice: 'Account was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def paypal_recipient_accounts_params
    	params.require(:paypal_recipient_account).permit(:email)
    end
end
