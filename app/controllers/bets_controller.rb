class BetsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_bet, only: [:select, :show, :edit, :update, :destroy, :payment, :pay_process, :mark_complete, :evaluate_if_current_user_mark_complete]
  before_action :set_post, only: [:create, :select, :payment, :pay_process, :evaluate_if_available_for_application, :evaluate_if_current_user_mark_complete]
  before_filter :evaluate_if_available_for_application, only: [:create]
  before_filter :evaluate_if_selected_limit_reached, only: [:select]
  before_filter :evaluate_if_current_user_mark_complete, only: [:mark_complete]
  before_filter :check_user, only: [:payment, :pay_process]

  def new
    @bet = Bet.new
  end

  def create
    @user = current_user
    if @post.user == @user
      redirect_to @post, alert: "You cannot claim your own fund."
      return
    end
    if @post.bets.pluck(:user_id).include?(current_user.id)
      redirect_to @post, alert: "You have submitted your application."
      return
    end
    
    @bet = @user.bets.build(bet_params)
    @bet.post = @post

    respond_to do |format|
      if @bet.save
        if params[:documents]
          params[:documents].each { |document|
            @bet.proofs.create(document: document)
          }
        end
        Resque.enqueue(NotifyWorker, @post.user_id,
                                     "#{@bet.user.name} applied to your fund '#{@post.title}'",
                                     "#{@bet.user.name} applied to your fund '#{@post.title}'", 
                                     "Bet", @bet.id)
        format.html { redirect_to @post }
        #format.json { render action: 'show', status: :created, location: @bet }
      else
        format.html { redirect_to @post, alert: 'Oops, something went wrong.' }
        #format.json { render json: @bet.errors, status: :unprocessable_entity }
      end
    end
  end

  def evaluate_if_selected_limit_reached
    post = Post.friendly.find(params[:post_id])
    selected_bets_count = post.bets_past_selection.count
    if post.quantity <= selected_bets_count
      flash[:notice] = "All spots have been taken."
      redirect_to post
    end
  end

  def select
    if @post.bets_past_selection.pluck(:user_id).include?(@bet.user.id)
      redirect_to @post, alert: "You can only select the same user once."
      return
    end

    params.permit!
    @post = Post.friendly.find(params[:post_id])
    @bet = @post.bets.find_by_id(params[:id])
    wallet = current_user.wallet

    if wallet.amount > 0
      if wallet.amount >= @post.price

        if wallet.coupons >= @post.price
          wallet.coupons -= @post.price
          wallet.save
          redeemed_coupons = @post.price
          redeemed_credits = 0
        else
          difference = @post.price - wallet.coupons
          redeemed_coupons = wallet.coupons
          redeemed_credits = difference
          wallet.coupons = 0
          wallet.credits -= difference
          wallet.save
        end

        @bet.status = 'Selected'
        @bet.save

        order = Order.new
        order.user_id = current_user.id
        order.bet_id = @bet.id
        order.amount = @post.price
        order.post_id = @post.id
        order.redeemed_credits = redeemed_credits
        order.redeemed_coupons = redeemed_coupons
        order.save!

        Resque.enqueue(NotifyWorker, @bet.user_id, 
                                     "#{@post.user.name} selected you on '#{@post.title}'",
                                     "#{@post.user.name} selected you on '#{@post.title}'",
                                     "Order", order.id)

        flash[:notice] = "Order ##{order.token_with_prefix} processed successfully with credits."
        redirect_to @post
      elsif wallet.amount < @post.price
        redirect_to :controller => :bets, :action=> :payment, :id => @bet.id, :post_id => @post.id
      end
    else
      redirect_to :controller => :bets, :action=> :payment, :id => @bet.id, :post_id => @post.id
    end
  end

  def mark_complete
    @post = Post.friendly.find(params[:post_id])
    @bet = @post.bets.find_by_id(params[:id])
    @bet.status = "Submitted"

    if @bet.save
      Resque.enqueue(NotifyWorker, @post.user_id,
                                   "#{@bet.user.name} completed the fund '#{@post.title}'",
                                   "#{@bet.user.name} completed the fund '#{@post.title}'",
                                   "Bet", @bet.id)
      redirect_to @post
      @bet.delay(run_at: 3.days.from_now).change_to_credited
      current_user.wallet.delay(run_at: 3.days.from_now).load_credits(@post.price)
    else
      flash[:notice] = 'Oops, something went wrong. Please try again.'
      redirect_to @post
    end
  end

  def payment
    if Order.where(:post_id => @post.id, :bet_id => @bet.id).first
      redirect_to @post
    else
      @subtotal = @post.price - current_user.wallet.amount.to_f
      @handling_fee = @subtotal * 0.1
      @final_payment = @subtotal * 1.1
    end
  end

  def pay_process
    if Order.where(:post_id => @post.id, :bet_id => @bet.id).first
      redirect_to @post
    else
      @subtotal = @post.price - current_user.wallet.amount.to_f
      @final_payment = @subtotal * 1.1
      if params[:gateway] != "paypal"
        flash[:notice] = 'Please select payment gateway.'
        redirect_to :controller => :bets, :id => @bet.id, :post_id => @post.id, :action => :payment
      end
    end
  end

  def evaluate_if_current_user_mark_complete
    if @bet.user != current_user
      flash[:notice] = "You cannot mark others' fund complete."
      redirect_to @post
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bet
      @bet = Bet.find(params[:id])
    end

    def set_post
      @post = Post.friendly.find(params[:post_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bet_params
      params.require(:bet).permit(:post_id, :user_id, :body)
    end

    def check_user
      unless (current_user.posts.where(:id => @post.id).first && @post.bets.where(:id => @bet.id).first)
        redirect_to @post
      end
    end

    def evaluate_if_available_for_application
      if !@post.available_for_application?
        flash[:notice] = "This fund is not open for application anymore."
        redirect_to @post
      end
    end
end
