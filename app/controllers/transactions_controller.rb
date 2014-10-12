class TransactionsController < ApplicationController
  skip_before_action :verify_authenticity_token
	
  def success
    bet = Bet.find(params[:bet_id])
    order = Order.find_by_bet_id(bet.id) rescue nil
    if order
      redirect_to bet.post, notice: "Order ##{order.token_with_prefix} has been successfully processed."
    else
      redirect_to bet.post, notice: "Your order is being processed. You will be notified."
    end
  end
	
  def failed
    bet = Bet.find(params[:bet_id])
    post = bet.post
    redirect_to bet.post, notice: 'Sorry, payment failed.'
  end

  def paypal_ipn
    paypal_notification = PaypalNotification.create(:params => params, :txn_id => params[:txn_id])

    case validate_paypal_ipn(request.raw_post)
    when true
      bet = Bet.find(params[:item_number])
      post = bet.post
      user = post.user
      wallet = user.wallet

      wallet.credits = 0
      wallet.coupons = 0
      wallet.save

      order = Order.new
      order.user_id = user.id
      order.bet_id = bet.id
      order.amount = post.price
      order.post_id = post.id
      order.redeemed_credits = wallet.credits
      order.redeemed_coupons = wallet.coupons
      order.save

      paypal_notification.order_id = order.id
      paypal_notification.save

      Resque.enqueue(NotifyWorker, bet.user_id,
                                   "#{post.user.name} selected you on '#{post.title}'",
                                   "#{post.user.name} selected you on '#{post.title}'", 
                                   "Order", order.id)

      Resque.enqueue(NotifyWorker, post.user_id,
                                   "You selected #{bet.user.name} on '#{post.title}'. Your order number is #{order.token_with_prefix}",
                                   "You selected #{bet.user.name} on '#{post.title}'. Your order number is #{order.token_with_prefix}", 
                                   "Order", order.id)

      render :nothing => true
    when false
      render :nothing => true
    when "FAILED"
      render :status => 500
    end
  end

  private
  def validate_paypal_ipn(raw)
    begin
      uri = URI.parse('https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_notify-validate')
      http = Net::HTTP.new(uri.host, uri.port)
      http.open_timeout = 60
      http.read_timeout = 60
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.use_ssl = true
      response = http.post(uri.request_uri, raw, 'Content-Length' => "#{raw.size}").body
      bet = Bet.find(params[:item_number])
      post = bet.post
      if (response == "VERIFIED" && params[:receiver_email] == Figaro.env["PAYPAL_USERNAME_DEV"] &&  params[:payment_status] == "Completed" &&  params[:mc_currency] == "USD" &&  PaypalNotification.where(:txn_id => params[:txn_id]).where.not(:order_id => nil).count == 0)
        return true if (((post.price - post.user.wallet.amount)*1.1).to_f == params[:mc_gross].to_f)
        wallet = post.user.wallet
        wallet.credits += (params[:mc_gross].to_f)/1.1
        wallet.save
        Resque.enqueue(NotifyWorker, post.user_id,
                                     "Your order is failed. You tried selecting #{bet.user.name} on '#{post.title}'. Kindly try it again. <br> $#{(params[:mc_gross].to_f)/1.1} has been added to your wallet",
                                     "Your order is failed. You tried selecting #{bet.user.name} on '#{post.title}'. Kindly try it again. <br> $#{(params[:mc_gross].to_f)/1.1} has been added to your wallet", 
                                     "Bet", bet.id)
      end
    rescue
    end

    return "FAILED" unless response
    return false
  end
end
