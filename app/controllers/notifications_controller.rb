class NotificationsController < ApplicationController
	before_filter :authenticate_user!
	def index
		@title = 'Notifications'
		@notification_receipts = current_user.mailbox.receipts.paginate(page: params[:page], per_page: 15).order('created_at desc')
	end
	def show
		@title = 'Notifications'
		@notification_receipt = Mailboxer::Receipt.find(params[:id])
	end
	def mark_read
		@notification_receipt = Mailboxer::Receipt.find(params[:id])
		@notification_receipt.mark_as_read
		redirect_to notification_path(@notification_receipt.notification)
	end
end