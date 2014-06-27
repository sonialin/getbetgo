class PagesController < ApplicationController
	before_filter :authenticate_user!, only: [:finances]
  def about
  end

  def contact
  end

  def finances
  	@user = current_user
    @posts = @user.posts.paginate(page: params[:page], per_page: 15).order('updated_at DESC')
    @bets = @user.bets.paginate(page: params[:page], per_page: 15).order('updated_at DESC')
    @contributions_sum = @user.posts.inject(0) {|sum, post| sum + post.claimed_fund}
    @credits_sum = @user.bets.where(:status => 'Funded').inject(0) {|sum, bet| sum + bet.post.price}
  	@paypal_recipient_account = PaypalRecipientAccount.new  
  end
end
