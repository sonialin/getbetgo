class ModificationRequestsController < ApplicationController
	before_filter :authenticate_user!

	def create
	params.permit!
    @modification_request = current_user.modification_requests.build(params[:modification_request])
    @bet = @modification_request.reply.bet

    if @modification_request.save
        Resque.enqueue(NotifyWorker, @bet.user_id,
                                     "#{@bet.post.user.name} requested a modification to your fund application",
                                     "#{@bet.post.user.name} requested a modification to your fund application '#{@bet.post.title}'",
                                     "Bet", @bet.id)
    	redirect_to :back
    else
    	flash[:notice] = "Oops - something went wrong. Please try again."
    	redirect_to :back
    end
  end
end
