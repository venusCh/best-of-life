class UserMailer < ApplicationMailer
	default from: 'hello@givers-app.org'

	def send_notification(user)
		@user = user
		@url = 'http://giversapp.org'
		mail(to: @user.email, subject: "You have few new messages!")
	end
end
