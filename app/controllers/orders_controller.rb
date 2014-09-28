class OrdersController < ApplicationController
	before_action :set_order, only: [:show]
	before_filter :authenticate_user!
	before_action :check_user

	def show
		@discount = @order.redeemed_credits + @order.redeemed_coupons
		@payment_amount = @order.amount - @discount
		@handling_fee = @payment_amount * 0.1
		@total_payment_w_discount = @payment_amount + @handling_fee
	end

	private
		def set_order
      @order = Order.find_by_token(params[:token])
    end

		def check_user
      render 'errors/forbidden' unless @order.user == current_user
    end
end