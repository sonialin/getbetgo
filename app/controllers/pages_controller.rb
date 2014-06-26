class PagesController < ApplicationController
	before_filter :authenticate_user!, only: [:finances]
  def about
  end

  def contact
  end

  def finances
  	@user = current_user
  	@bets = @user.bets.order('created_at desc')
    @posts = @user.posts.order("created_at desc")
    @credit_sum = @bets.inject(0) {|sum, bet| sum + bet.post.price}
  	@paypal_recipient_account = PaypalRecipientAccount.new  
  end
end
