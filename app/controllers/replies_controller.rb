class RepliesController < ApplicationController
	before_filter :authenticate_user!

	def create
		params.permit!
    @reply = current_user.replies.build(params[:reply])
    @post = @reply.bet.post
    @bet = @reply.bet

    if @reply.save
      if (@reply.bet.selected? or @reply.bet.modified?) or @reply.bet.submitted?
        if @reply.user == @bet.user
          @post.user.notify("#{@bet.user.name} commented on application to your fund",
                        "#{@bet.user.name} commented on application to your fund '#{@bet.post.title}'", 
                        notified_object = @reply)
        elsif @reply.user == @post.user
          @bet.user.notify("#{@post.user.name} commented on your fund application",
                        "#{@post.user.name} commented on your application to the fund '#{@bet.post.title}'", 
                        notified_object = @reply)
        end
      end
      if @reply.bet.awaiting_modification?
        if @reply.user == @bet.user
          @reply.bet.status = "Modified"
          @reply.bet.save!
          @post.user.notify("#{@bet.user.name} updated application to your fund",
                        "#{@bet.user.name} updated application to your fund '#{@bet.post.title}'", 
                        notified_object = @reply)
        else
          @bet.user.notify("#{@post.user.name} commented on your fund application",
                        "#{@post.user.name} commented on your application to the fund '#{@bet.post.title}'", 
                        notified_object = @reply)
        end
      end
			if params[:documents]
        params[:documents].each { |document|
          @reply.proofs.create(document: document)
        }
      end
    	redirect_to :back
    else
    	flash[:notice] = "Oops - something went wrong."
    	redirect_to :back
    end
  end
end
