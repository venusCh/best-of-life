class UserMailer < ApplicationMailer
	default from: 'hello@givers-app.org'

	def send_request_notification(user, requester, object, msg)
		@user = user
		@requester = requester
		@object = object
		@msg = msg
		@url = 'http://giversapp.org'
		mail(to: @user.email, subject: "You have a new request")
	end

	def send_accept_notification(user, giver, object)
		@user = user
		@giver = giver
		@object = object
		@url = 'http://giversapp.org'
		mail(to: @user.email, subject: "Your request accepted!")
	end

	def send_request_summary_notification(user, request_count, object_names) 
		@user = user
		@request_count = request_count
		@object_names = object_names
		@url = 'http://giversapp.org'
		mail(to: @user.email, subject: "You have #{request_count} new request".pluralize(request_count))
	end

end
