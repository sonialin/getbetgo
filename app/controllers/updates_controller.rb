class UpdatesController < ApplicationController
  def create
  	@post = Post.find(params[:post_id])
  	@bet = Bet.find(params[:bet_id])
    @update = @bet.create_update(update_params)
    @update.user = current_user
    @update.post = @post

    if @update.save
    	flash[:notice] = "Your update has been posted!"
    	redirect_to @post
    else
    	flash[:notice] = "Fail."
    	redirect_to @post
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def update_params
    	params.require(:update).permit(:body)
    end
end
