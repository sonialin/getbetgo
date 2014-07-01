class CustomNotificationMailer < Mailboxer::NotificationMailer
	def send_email(notification, receiver)
	  new_notification_email(notification, receiver)
	end

	def new_notification_email(notification, receiver)
	  @notification = notification
	  @receiver     = receiver
	  set_subject(notification)
	  mail :to => receiver.send(Mailboxer.email_method, notification),
	       :subject => @subject + ' on fundwok',
	       :template_path => 'mailboxer/custom_notification_mailer',
	       :template_name => 'new_notification_email'
	end
end