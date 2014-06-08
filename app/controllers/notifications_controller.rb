class NotificationsController < ApplicationController
	before_filter :authenticate_user!
	def index
		@notifications = current_user.mailbox.notifications
	end
end