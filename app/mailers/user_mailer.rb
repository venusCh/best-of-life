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

		@count_string = ""
		if request_count == 1
			@count_string = "a new"
		else
			@count_string = "#{request_count} new"
		end

		mail(to: @user.email, subject: "You have #{@count_string} request".pluralize(request_count))
	end

	def send_7day_reminder(user, object, transfer)
		@user = user
		@object = object
		@transfer = transfer
		@url = 'http://giversapp.org'

		mail(to: @user.email, subject: "reGive reminder for #{object.name}")
	end

	def send_lastday_reminder(user, object, transfer)
		@user = user
		@object = object
		@transfer = transfer
		@url = 'http://giversapp.org'

		mail(to: @user.email, subject: "reGive #{object.name} today")
	end

	def send_overdue_reminder(user, object, transfer)
		@user = user
		@object = object
		@transfer = transfer
		@url = 'http://giversapp.org'

		mail(to: @user.email, subject: "reGive overdue for #{object.name}")
	end

	def send_wishlist_item_available(user, object)
		@user = user
		@object = object
		@url = 'http://giversapp.org'

		mail(to: @user.email, subject: "#{object.name} in your wishlist now available!")
	end

end
