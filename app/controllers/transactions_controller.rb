class TransactionsController < ApplicationController
	skip_before_action :verify_authenticity_token
	
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
