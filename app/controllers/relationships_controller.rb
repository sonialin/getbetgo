class RelationshipsController < ApplicationController
	before_filter :authenticate_user!

	def create
		params.permit!
		@relationship = Relationship.new(params[:relationship])
		@relationship.follower = current_user

		if @relationship.save
			Resque.enqueue(NotifyWorker, @relationship.followed_id,
																	 "#{@relationship.follower.name} just followed you",
																	 "#{@relationship.follower.name} just followed you",
																	 "Relationship", @relationship.id)
			redirect_to :back
		else
			flash[:error] = "Oops, something went wrong."
			redirect_to :back
		end
	end

	def destroy
		relationship = Relationship.find(params[:id])
		relationship.destroy
		redirect_to :back
	end
end
