class TransactionsController < ApplicationController
	skip_before_action :verify_authenticity_token
	
	def success
	  p params
	  #adads
	  @post = Post.friendly.find(params[:post_id])
	  order = Order.new
	  order.user_id = current_user.id
	  order.post_id = @post.id
	  order.amount = @post.quantity * @post.price
	  order.post_id = @post.id
	  order.save(:validate=>false)
	  redirect_to @post, notice: 'Payment has been successfully done.'
	end
	
	
	def failed
	  p params
	  @post = Post.friendly.find(params[:post_id])
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
