class OrdersController < ApplicationController
	def show
		@order = Order.find(params[:id])
		@discount = @order.redeemed_credits + @order.redeemed_coupons
		@payment_amount = @order.amount - @discount
		@handling_fee = @payment_amount * 0.1
		@total_payment_w_discount = @payment_amount + @handling_fee
	end
end