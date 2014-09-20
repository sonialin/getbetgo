class FundTransfersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def success
  	@fund = Fund.new
  	@fund.user = current_user
  	@fund.bet_id = params[:bet_id]
  	@fund.ip_address = request.remote_ip
  	@post = Post.friendly.find(params[:post_id])
  	@fund.amount = @post.price
  	@fund.save
    Resque.enqueue(NotifyWorker, @fund.bet.user_id, 
                                 "You got a fund from #{@post.user.name} on '#{@post.title}'",
                                 "You got a fund from #{@post.user.name} on '#{@post.title}'",
                                 "Fund", @fund.id)
  	redirect_to @post, notice: "Fund transfered!" 
  end

  def failed
  end
end