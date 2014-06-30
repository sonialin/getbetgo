class FundTransfersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def success
  	p params
  	@fund = Fund.new
  	@fund.user = current_user
  	@fund.bet_id = params[:bet_id]
  	@fund.ip_address = request.remote_ip
  	@post = Post.friendly.find(params[:post_id])
  	@fund.amount = @post.price
  	@fund.save
    @fund.create_activity :create, owner: @post.user, recipient: @fund.bet.user
    @fund.bet.user.notify("You got a fund from #{@post.user.name} on '#{@post.title}'",
                          "You got a fund from #{@post.user.name} on '#{@post.title}'",
                          notified_object = @fund)
  	redirect_to @post, notice: "Fund transfered!" 
  end

  def failed
  end
end