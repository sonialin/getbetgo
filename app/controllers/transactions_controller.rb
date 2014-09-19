class TransactionsController < ApplicationController
	skip_before_action :verify_authenticity_token
	
	def success
		wallet = current_user.wallet
	  @bet = Bet.find(params[:bet_id])
	  @order = Order.new
	  @order.user_id = current_user.id
	  @order.bet_id = @bet.id
	  @post = @bet.post
	  @order.amount = @post.price
	  @order.post_id = @post.id
	  @order.redeemed_credits = wallet.credits
	  @order.redeemed_coupons = wallet.coupons
	  @order.save!

	  wallet.credits = 0
	  wallet.coupons = 0
	  wallet.save
	  
    @bet.user.notify("#{@post.user.name} selected you on '#{@post.title}'",
                  		"#{@post.user.name} selected you on '#{@post.title}'", 
                 			notified_object = @order)
	  redirect_to @post, notice: "Order number #{@order.token} has been successfully processed."
	end
	
	def failed
	  @bet = Bet.find(params[:bet_id])
	  @post = @bet.post
	  redirect_to @post, notice: 'Sorry, payment failed.'
	end
end
