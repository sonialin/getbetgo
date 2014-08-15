class RepliesController < ApplicationController
	before_filter :authenticate_user!

	def create
		params.permit!
    @reply = current_user.replies.build(params[:reply])
    @post = @reply.bet.post
    @bet = @reply.bet

    if @reply.save
      if @reply.bet.awaiting_modification? && !(@reply.user == @post.user)
        @reply.bet.status = "Submitted"
        @reply.bet.save!
        @post.user.notify("#{@bet.user.name} modified application to your fund",
                        "#{@bet.user.name} modified application to your fund '#{@bet.post.title}'", 
                        notified_object = @bet)
      end
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
