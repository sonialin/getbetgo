class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :payment, :pay_process]
  # before_action :set_gateway
  before_filter :authenticate_user!, except: [:index, :show, :getposts]

  # GET /posts
  # GET /posts.json
  def index
    city = request.location.city
    country = request.location.country

    per_page = 12
    followed_ids = [-1]

    if current_user
      if current_user.followeds.count > 0
        followed_ids = current_user.followeds.map(&:id)
      end
    end

    if params[:tag]
      @posts = Post.tagged_with(params[:tag])
      @tag = params[:tag]
    else
      @posts = Post.all
      @tag = ""
    end

    @rec_or_fol_posts = @posts.where("user_id IN (?) OR (location LIKE ? AND location LIKE ?)", followed_ids, "%#{city}%", "%#{country}%")
    count = @rec_or_fol_posts.count

    if count > per_page
      @rec_or_fol_posts = @rec_or_fol_posts.limit(per_page)
      @next_page = true
      @type = 1
      @offset = per_page
    else
      if count > 0
        rec_or_fol_posts_ids = @rec_or_fol_posts.map(&:id)
        @other_posts = @posts.where("posts.id NOT IN (?)",rec_or_fol_posts_ids).order("updated_at desc")
      else
        @other_posts = @posts.order("updated_at desc")
      end

      if @other_posts.count > per_page - count
        @next_page = true
        @type = 2
        @offset = per_page - count
      else
        @next_page = false
      end

      @other_posts = @other_posts.limit(per_page - count)
    end

    @posts = []
    @post_type = []

    if @rec_or_fol_posts
      @rec_or_fol_posts.each do |post|
        @posts << post
        if (not post.location.nil?) and post.location.include? city and post.location.include? country
          @post_type << 'r'
        else
          @post_type << 'f'
        end
      end
    end

    if @other_posts
      @other_posts.each do |post|
        @posts << post
        @post_type << 'o'
      end
    end

    respond_to do |format|
      format.html
    end
  end

  # POST /getposts
  def getposts
    city = request.location.city
    country = request.location.country

    per_page = 12
    followed_ids = [-1]

    if current_user
      if current_user.followeds.count > 0
        followed_ids = current_user.followeds.map(&:id)
      end
    end

    if params[:category] == "all"
      if params[:tag] == ""
        @posts = Post.all
      else
        @posts = Post.tagged_with(params[:tag])
      end
    elsif params[:category] == "Others"
      if params[:tag] == ""
        @posts = Post.where(:category => nil)
      else
        @posts = Post.tagged_with(params[:tag]).where(:category => nil)
      end
    else
      if params[:tag] == ""
        @posts = Post.where(:category => params[:category].split(/(?=[A-Z])/).join(' '))
      else
        @posts = Post.tagged_with(params[:tag]).where(:category => params[:category].split(/(?=[A-Z])/).join(' '))
      end
    end

    @type = params[:type].to_i
    @offset = params[:offset].to_i

    rec_or_fol_posts_ids = @posts.where("user_id IN (?) OR (location LIKE ? AND location LIKE ?)", followed_ids,"%#{city}%", "%#{country}%").map(&:id)

    if @type == 1
      @rec_or_fol_posts = @posts.where("user_id IN (?) OR (location LIKE ? AND location LIKE ?)", followed_ids,"%#{city}%", "%#{country}%").offset(@offset)
      count = @rec_or_fol_posts.count

      if count > per_page
        @rec_or_fol_posts = @rec_or_fol_posts.limit(per_page)
        @next_page = true
        @offset += per_page
      else
        @type = 2
        if rec_or_fol_posts_ids.count > 0
          @other_posts = @posts.where("posts.id NOT IN (?)",rec_or_fol_posts_ids).order("updated_at desc")
        else
          @other_posts = @posts.order("updated_at desc")
        end

        if @other_posts.count > per_page - count
          @next_page = true
          @offset = per_page - count
        else
          @next_page = false
        end
        @other_posts = @other_posts.limit(per_page - count)
      end

    elsif @type == 2
      if rec_or_fol_posts_ids.count > 0
        @other_posts = @posts.where("posts.id NOT IN (?)",rec_or_fol_posts_ids).order("updated_at desc").offset(@offset)
      else
        @other_posts = @posts.order("updated_at desc").offset(@offset)
      end
      if @other_posts.count > per_page
        @next_page = true
        @offset += per_page
      else
        @next_page = false
      end

      @other_posts = @other_posts.limit(per_page)
    end

    @posts = []
    @post_type = []

    if @rec_or_fol_posts
      @rec_or_fol_posts.each do |post|
        @posts << post

        if (not post.location.nil?) and post.location.include? city and post.location.include? country
            @post_type << 'r'
        else
            @post_type << 'f'
        end
      end
    end

    if @other_posts
      @other_posts.each do |post|
        @posts << post
        @post_type << 'o'
      end
    end

    respond_to do |format|
      format.js { render 'index.js.erb' }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
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
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :description, :image, :image_url, :price, :quantity, :tag_list, :category, :location, :free, :service)
    end
end
