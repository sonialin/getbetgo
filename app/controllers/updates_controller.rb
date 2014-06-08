class UpdatesController < ApplicationController
  before_filter :authenticate_user!
  
  def create
  	@post = Post.friendly.find(params[:post_id])
  	@bet = Bet.find(params[:bet_id])
    @update = @bet.create_update(update_params)
    @update.user = current_user
    @update.post = @post

    if @update.save
      @update.create_activity :create, owner: @update.user, recipient: @post.user
      @post.user.notify("#{@update.user.name} submitted an update on #{@post.title}",
                        "#{@update.user.name} submitted an update on #{@post.title}"
                        )
    	flash[:notice] = "Your update has been posted!"
    	redirect_to :back
    else
    	flash[:notice] = "Fail."
    	redirect_to :back
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def update_params
    	params.require(:update).permit(:body)
    end
end
