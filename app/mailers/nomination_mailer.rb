class NominationMailer < ActionMailer::Base
  default from: "no-reply@fundwok.com"

  def send_nomination(nomination, fund_url)
  	email = nomination.email
  	@sender_name = nomination.sender_name
  	@fund_url = fund_url
  	@fund_title = nomination.post.title
  	@body = nomination.body
  	if nomination.receiver_id != nil
  		@receiver_name = User.find(nomination.receiver_id).name
  	end
    mail(:to => email, subject: @sender_name + ' Nominates You for a Fund on FundWok')
  end
end
