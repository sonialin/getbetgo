class RepliesController < ApplicationController
	before_filter :authenticate_user!

	def create
		params.permit!
    @reply = current_user.replies.build(params[:reply])

    if @reply.save
			if params[:documents]
        params[:documents].each { |document|
          @reply.proofs.create(document: document)
        }
      end
    	flash[:notice] = "Your reply has been posted!"
    	redirect_to :back
    else
    	flash[:notice] = "Fail."
    	redirect_to :back
    end
  end
end
