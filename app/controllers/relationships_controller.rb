class RelationshipsController < ApplicationController
	def create
		params.permit!
		@relationship = Relationship.new(params[:relationship])
		@relationship.follower = current_user

		if @relationship.save
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
