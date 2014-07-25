class PagesController < ApplicationController
	before_filter :authenticate_user!, only: [:giving, :receiving]
  def about
    @title = 'About Us'
  end

  def contact
  end

  def giving
    @title = 'Finances'
    @user = current_user
    @posts = current_user.posts.paginate(page: params[:page], per_page: 10).order('updated_at DESC')
    @contributions_sum = @user.posts.inject(0) {|sum, post| sum + post.claimed_fund}
    @credits_sum = @user.bets.where(:status => 'Funded').inject(0) {|sum, bet| sum + bet.post.price}
    @paypal_recipient_account = PaypalRecipientAccount.new 
  end

  def receiving
    @title = 'Finances'
    @user = current_user
    @bets = @user.bets.paginate(page: params[:page], per_page: 10).order('updated_at DESC')
    @contributions_sum = @user.posts.inject(0) {|sum, post| sum + post.claimed_fund}
    @credits_sum = @user.bets.where(:status => 'Funded').inject(0) {|sum, bet| sum + bet.post.price}
    @paypal_recipient_account = PaypalRecipientAccount.new 
  end

  def howitworks
  end

  def termsofuse
  end

  def privacystatement
  end

  def faq
  end
end
