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
    @orders = current_user.orders.paginate(page: params[:page], per_page: 10).order('updated_at DESC')
    @contributions_sum = @user.contributions
    @credits_sum = @user.credits
    @paypal_recipient_account = PaypalRecipientAccount.new 
  end

  def receiving
    @title = 'Finances'
    @user = current_user
    @bets = @user.bets.paginate(page: params[:page], per_page: 10).order('updated_at DESC')
    @contributions_sum = @user.contributions
    @credits_sum = @user.credits
    @paypal_recipient_account = PaypalRecipientAccount.new 
  end

  def howitworks
    @post = Post.find_by_title("I am giving $30.0 to 5 people who want to learn coding")
  end

  def comingsoon
  end

  def termsofuse
  end

  def privacystatement
  end

  def faq
  end
end
