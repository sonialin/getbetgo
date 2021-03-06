class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :payment, :pay_process, :upvote, :publish]
  # before_action :set_gateway
  before_filter :authenticate_user!, except: [:index, :show, :getbets]
  before_action :check_user, only: [:update, :destroy, :edit]

  include PostsHelper

  APPLICANTS_PER_PAGE = 10

  # GET /posts
  # GET /posts.json
  def index
    es_query = Posts::ElasticsearchApi.new.build_es_query(params, true)
    @tag = params[:tag]
    @category = params[:category]
    @location = params[:location]
    @subcategory = params[:subcategory]
    @search = params[:search]
    page = params[:page] || 1
    @posts, @next_page = fetch_page_posts(es_query, page.to_i)

    respond_to do |format|
      format.html
      format.js { render 'index.js.erb' }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    impressionist(@post)
    @nomination = Nomination.new
    @per_page_bets = APPLICANTS_PER_PAGE
    @bet = Bet.new
    @bets = @post.bets.order_by_updated_at_desc
    @reply = Reply.new
    @modification_request = ModificationRequest.new
    @user_info = @post.user.user_info
    @current_user_bet = @post.bets.filter_by_user(current_user.id) if (current_user && (current_user != @post.user))
    @relationship = Relationship.where(
      follower_id: current_user.id,
      followed_id: @post.user.id
      ).first_or_initialize if current_user
    @title = @post.title
  end

  def getbets
    @per_page_bets = APPLICANTS_PER_PAGE
    @bets = Post.find(params[:post].to_i).bets.order("updated_at desc").offset(@per_page_bets*(params[:page].to_i - 1)).limit(@per_page_bets)
    respond_to do |format|
      format.js
    end
  end

  # GET /posts/new
  def new
    @title = "New Fund"
    @post = current_user.posts.new(:price => params[:price], :quantity => params[:quantity], :criteria => params[:criteria])
  end

  # GET /posts/1/edit
  def edit
    @title = "Edit Fund"
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.posts.new(post_params)
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Fund was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post }
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
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  def upvote
    if current_user.voted_for? @post
      @post.unliked_by current_user
    else 
      current_user.likes @post
    end 
    redirect_to @post
  end

  def publish
    @post.change_to_published
    redirect_to @post
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.friendly.find(params[:id])
    end

    def check_user
      render 'errors/forbidden' unless @post.user == current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :description, :image, :price, :quantity, :tag_list, :subcategory_id, :service, :criteria, :published, :keep_open, :city_attributes => [:name, :latitude, :longitude, :full_name, :region_name, :country_name])
    end
end
