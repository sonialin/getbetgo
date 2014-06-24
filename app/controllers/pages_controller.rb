class PagesController < ApplicationController
	before_filter :authenticate_user!, only: [:finances]
  def about
  end

  def contact
  end

  def finances
  	@user = current_user
  	@bets = @user.bets
  	@paypal_recipient_account = PaypalRecipientAccount.new
  end
end
