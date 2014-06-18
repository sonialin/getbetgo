class BetsController < ApplicationController
  before_action :set_bet, only: [:show, :edit, :update, :destroy, :receive, :receive_process, :payment, :pay_process]
  before_action :set_post, only: [:payment, :pay_process]
  before_filter :evaluate_if_current_user_claim_bet, only: [:receive, :receive_process]
  before_filter :evaluate_if_selected_limit_reached, only: [:select]

  # GET /bets
  # GET /bets.json
  def index
    @bets = Bet.all
  end

  # GET /bets/1
  # GET /bets/1.json
  def show
    if current_user
      @current_user_bet = @bet.post.bets.where(:user_id => current_user.id)
    end
    @update = Update.new
  end

  # GET /bets/new
  def new
    @bet = Bet.new
  end

  # GET /bets/1/edit
  def edit
  end

  # POST /bets
  # POST /bets.json
  def create
    @user = current_user
    @post = Post.friendly.find(params[:post_id])
    if @post.user == @user
      redirect_to @post, alert: "Cannot claim your own bets!"
      return
    end
    
    @bet = @user.bets.build(bet_params)
    @bet.post = @post

    respond_to do |format|
      if @bet.save
        @bet.create_activity :create, owner: @bet.user, recipient: @post.user
        @post.user.notify("#{@bet.user.name} applied to your fund #{@post.title}",
                          "#{@bet.user.name} applied to your fund #{@post.title}", 
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
  def update
    respond_to do |format|
      if @bet.update(bet_params)
        format.html { redirect_to @bet, notice: 'Bet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @bet.errors, status: :unprocessable_entity }
      end
    end
  end

  def evaluate_if_current_user_claim_bet
    post = @bet.post
    if @bet.user != current_user
      flash[:notice] = "You can only claim your own fund!"
      redirect_to post
    end
  end

  def evaluate_if_selected_limit_reached
    post = Post.friendly.find(params[:post_id])
    selected_bets = post.bets.where(:status => ["Selected", "Submitted", "Funded"]).all
    if post.quantity == selected_bets.length
      flash[:notice] = "Limit reached"
      redirect_to post
    end
  end

  def receive
  end

  def receive_process
    if params[:gateway] != "paypal"
      flash[:notice] = 'Please select a method to receive fund.'
      redirect_to :controller => :bets, :post_id => @bet.post.id, :id => @bet.id, :action => :receive
    else
      send_money(@bet.post.price*100)
    end
  end

  def send_money(how_much_in_cents, options = {})
    # if @bet.user.paypal_recipient_accounts.empty?
    #   flash[:notice] = 'No account present.'
    #   redirect_to :controller => :bets, :post_id => @bet.post.id, :id => @bet.id, :action => :receive
    # end

    credentials = {
      "USER" => configatron.paypal_username,
      "PWD" => configatron.paypal_pwd,
      "SIGNATURE" => configatron.paypal_signature,
    }
   
    params = {
      "METHOD" => "MassPay",
      "CURRENCYCODE" => "USD",
      "RECEIVERTYPE" => "EmailAddress",
      "L_EMAIL0" => @bet.user.paypal_recipient_accounts.first.email,
      "L_AMT0" => ((how_much_in_cents.to_i)/100.to_f).to_s,
      "VERSION" => "51.0"
    }
   
    endpoint = "https://api-3t.sandbox.paypal.com"
    url = URI.parse(endpoint)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    all_params = credentials.merge(params)
    stringified_params = all_params.collect { |tuple| "#{tuple.first}=#{CGI.escape(tuple.last)}" }.join("&")
   
    response = http.post("/nvp", stringified_params)
    @result = Rack::Utils.parse_nested_query(response.body)

    if (@result["ACK"]=="Success")
      flash[:notice] = 'Success!'
      redirect_to :controller => :fund_transfers, :post_id => @bet.post.id, :bet_id => @bet.id, :action => :success
    else
      flash[:notice] = 'Oops, something went wrong. Please try again.'
      redirect_to :controller => :bets, :post_id => @bet.post.id, :id => @bet.id, :action => :receive
    end
  end

  # DELETE /bets/1
  # DELETE /bets/1.json
  def destroy
    @bet.destroy
    respond_to do |format|
      format.html { redirect_to bets_url }
      format.json { head :no_content }
    end
  end

  def select
    params.permit!
    @post = Post.friendly.find(params[:post_id])
    @bet = @post.bets.find_by_id(params[:id])
    redirect_to :controller => :bets, :action=> :payment, :id => @bet.id, :post_id => @post.id
    # @bet.select
    # if @bet.status == "Selected"
    #   flash[:notice] = "The bet has been selected."
    # else 
    #   flash[:notice] = "Oops, something went wrong."
    # end
    # redirect_to @post
  end

  def payment
  end

  def pay_process
    if params[:gateway] != "paypal"
      flash[:notice] = 'Please select payment gateway.'
      redirect_to :controller=>:bets, :id => @bet.id, :post_id => @post.id, :action=>:payment
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
