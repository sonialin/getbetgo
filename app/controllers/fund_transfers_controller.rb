class FundTransfersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def success
  	p params
  	@fund = Fund.new
  	@fund.user = current_user
  	@fund.bet_id = params[:bet_id]
  	@fund.ip_address = request.remote_ip
  	@post = Post.find(params[:post_id])
  	@fund.amount = @post.price
  	@fund.save(:validate=>false)
  	redirect_to @post
  end

  def failed
  end
end