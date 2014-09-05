class BetsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_bet, only: [:select, :show, :edit, :update, :destroy, :payment, :pay_process, :mark_complete, :evaluate_if_current_user_mark_complete]
  before_action :set_post, only: [:select, :payment, :pay_process]
  before_filter :evaluate_if_selected_limit_reached, only: [:select]
  before_filter :evaluate_if_current_user_mark_complete, only: [:mark_complete]

  # GET /bets
  # GET /bets.json
  # def index
  #   @bets = Bet.all
  # end

  # GET /bets/1
  # GET /bets/1.json
  # def show
  #   if (current_user && current_user == @bet.user)
  #     @current_user_bet = @bet.post.bets.where(:user_id => current_user.id)
  #   else
  #     redirect_to @bet.post
  #   end
  # end

  # GET /bets/new
  def new
    @bet = Bet.new
  end

  # GET /bets/1/edit
  # def edit
  # end

  # POST /bets
  # POST /bets.json
  def create
    @user = current_user
    @post = Post.friendly.find(params[:post_id])
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
        @post.user.notify("#{@bet.user.name} applied to your fund '#{@post.title}'",
                          "#{@bet.user.name} applied to your fund '#{@post.title}'", 
                          notified_object = @bet)
        format.html { redirect_to @post, notice: 'Application was successfully submitted!' }
        #format.json { render action: 'show', status: :created, location: @bet }
      else
        format.html { redirect_to @post, alert: 'Oops, something went wrong.' }
        #format.json { render json: @bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bets/1
  # PATCH/PUT /bets/1.json
  # def update
  #   respond_to do |format|
  #     if @bet.update(bet_params)
  #       format.html { redirect_to @bet, notice: 'Bet was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: 'edit' }
  #       format.json { render json: @bet.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  def evaluate_if_selected_limit_reached
    post = Post.friendly.find(params[:post_id])
    selected_bets_count = post.bets_past_selection.count
    if post.quantity <= selected_bets_count
      flash[:notice] = "Limit reached"
      redirect_to post
    end
  end

  # DELETE /bets/1
  # DELETE /bets/1.json
  # def destroy
  #   @bet.destroy
  #   respond_to do |format|
  #     format.html { redirect_to bets_url }
  #     format.json { head :no_content }
  #   end
  # end

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
        wallet.amount -= @post.price
        wallet.save
        @bet.status = 'Selected'
        @bet.save

        order = Order.new
        order.user_id = current_user.id
        order.bet_id = @bet.id
        order.amount = @post.price
        order.post_id = @post.id
        order.credit = @post.price
        order.save!

        @bet.user.notify("#{@post.user.name} selected you on '#{@post.title}'",
                      "#{@post.user.name} selected you on '#{@post.title}'", 
                      notified_object = order)

        flash[:notice] = 'Payment made successfully with credits!'
        redirect_to @post
      elsif wallet.amount < @post.price
        @@payment_amount = @post.price - wallet.amount
        redirect_to :controller => :bets, :action=> :payment, :id => @bet.id, :post_id => @post.id
      end
    else
      @@payment_amount = @post.price
      redirect_to :controller => :bets, :action=> :payment, :id => @bet.id, :post_id => @post.id
    end
    # @bet.select
    # if @bet.status == "Selected"
    #   flash[:notice] = "The bet has been selected."
    # else 
    #   flash[:notice] = "Oops, something went wrong."
    # end
    # redirect_to @post
  end

  def mark_complete
    @post = Post.friendly.find(params[:post_id])
    @bet = @post.bets.find_by_id(params[:id])
    @bet.status = "Submitted"
    if @bet.save
      @post.user.notify("#{@bet.user.name} completed the fund '#{@post.title}'",
                          "#{@bet.user.name} completed the fund '#{@post.title}'", 
                          notified_object = @bet)
      flash[:notice] = 'You have marked the fund complete'
      redirect_to @post
    else
      flash[:notice] = 'Oops, something went wrong. Please try again.'
      redirect_to @post
    end
  end

  def payment
    @payment_amount = @@payment_amount
  end

  def pay_process
    @payment_amount = @@payment_amount
    if params[:gateway] != "paypal"
      flash[:notice] = 'Please select payment gateway.'
      redirect_to :controller => :bets, :id => @bet.id, :post_id => @post.id, :action => :payment
    end
  end

  def evaluate_if_current_user_mark_complete
    if @bet.user != current_user
      flash[:notice] = "You cannot mark complete others' fund."
      redirect_to post
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
end
