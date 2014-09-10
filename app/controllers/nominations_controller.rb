class NominationsController < ApplicationController

	def create
		params.permit!
    @nomination = Nomination.new(params[:nomination])
    @receiver = User.find_by_email(params[:nomination][:email])
    if current_user
    	@nomination.sender = current_user
    	@nomination.sender_name = current_user.name
    end
    if @receiver != nil
    	@nomination.receiver = @receiver
    end

    if @nomination.save
    	if @receiver != nil
    		@nomination.receiver.notify("#{@nomination.sender_name} Nominated You for a Fund on FundWok",
                          "#{@nomination.sender_name} nominated you for the fund '#{@nomination.post.title}'", 
                          notified_object = @nomination)
    	else
    		NominationMailer.send_nomination(@nomination, post_url(@nomination.post)).deliver
    	end
    	flash[:notice] = "Nomination successfully sent!"
    	redirect_to :back
    else
    	flash[:notice] = "Oops - something went wrong. Please try again."
    	redirect_to :back
    end
  end
end