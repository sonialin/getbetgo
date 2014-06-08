class TransactionsController < ApplicationController
	skip_before_action :verify_authenticity_token
	
	def success
	  @bet = Bet.find(params[:bet_id])
	  order = Order.new
	  order.user_id = current_user.id
	  order.bet_id = @bet.id
	  @post = @bet.post
	  order.amount = @post.price
	  order.post_id = @post.id
	  order.save!
	  order.create_activity :create, owner: @post.user, recipient: @bet.user
    @bet.user.notify("#{@post.user.name} selected you on #{@post.title}",
                  		"#{@post.user.name} selected you on #{@post.title}" 
                 		)
	  redirect_to @post, notice: 'Payment has been successfully done.'
	end
	
	
	def failed
	  @bet = Bet.find(params[:bet_id])
	  @post = @bet.post
	  redirect_to @post, notice: 'Sorry, payment failed.'
	end

	# def new
	# 	@order = Order.new
	# end

	# def create
	# 	@result = Braintree::Transaction.sale(
	#   :amount => params[:amount],
	#   :credit_card => {
	#     :number => params[:card],
	#     :expiration_date => params[:expiry]
	#   }
	# )
	# end

end
