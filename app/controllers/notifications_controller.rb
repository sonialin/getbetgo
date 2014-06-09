class NotificationsController < ApplicationController
	before_filter :authenticate_user!
	def index
		@notification_receipts = current_user.mailbox.receipts
	end
	def show
		@notification_receipt = Mailboxer::Receipt.find(params[:id])
	end
	def mark_read
		@notification_receipt = Mailboxer::Receipt.find(params[:id])
		@notification_receipt.mark_as_read
		redirect_to notification_path(@notification_receipt.notification)
	end
end