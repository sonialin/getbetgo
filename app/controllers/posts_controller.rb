class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :payment, :pay_process]
  # before_action :set_gateway
  before_filter :authenticate_user!, except: [:index, :show]

  # GET /posts
  # GET /posts.json
  def index
    if params[:tag]
      @posts = Post.tagged_with(params[:tag]).paginate(page: params[:page], per_page: 12).order("updated_at desc")
    else
      @posts = Post.paginate(page: params[:page], per_page: 12).order("updated_at desc")
    end

    @posts_business = Post.where(:category => 'Business').paginate(page: params[:page], per_page: 12).order("updated_at desc")
    @posts_education = Post.where(:category => 'Education').paginate(page: params[:page], per_page: 12).order("updated_at desc")
    @posts_lifestyle = Post.where(:category => 'Lifestyle').paginate(page: params[:page], per_page: 12).order("updated_at desc")
    @posts_socialimpact = Post.where(:category => 'Social Impact').paginate(page: params[:page], per_page: 12).order("updated_at desc")

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    redirect_to root_url if @post.user != current_user && !@post.paid?
    @bet = Bet.new
    @bets = @post.bets.order("updated_at desc")
    @update = Update.new
    if current_user
      @current_user_bet = @post.bets.where(:user_id => current_user.id)
    end
    @relationship = Relationship.where(
      follower_id: current_user.id,
      followed_id: @post.user.id
      ).first_or_initialize if current_user
  end

  # GET /posts/new
  def new
    @post = current_user.posts.new
  end

  # GET /posts/1/edit
  def edit
    @post = current_user.posts.friendly.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.posts.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to :controller => :posts, :action=> :payment, :id => @post.id }
        # format.html { redirect_to @post, notice: 'Post was successfully created.' }
        # format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    @post = current_user.posts.friendly.find(params[:id])
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = current_user.posts.friendly.find(params[:id])
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  def payment
  end

  def pay_process
    if params[:gateway] != "paypal"
      flash[:notice] = 'Please select payment gateway.'
      redirect_to :controller=>:posts, :id=>@post.id, :action=>:payment
      #redirect_to "posts/#{@post.id}/payment", notice: 'Please select payment gateway.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :description, :image, :image_url, :price, :quantity, :tag_list, :category)
    end
end
