module ApplicationHelper
	#
	# Summary emails that get sent end of day at certain time
	#

	def self.send_notifications
		puts "\ninside ApplicationHelper::send_notifications\n"
		puts User.all
		User.all.each do |user|
			send_notification_summary(user)
		end
	end

	def self.send_notification_summary(user)
		puts "\ninside ApplicationHelper::send_notification_summary\n"		
		new_conversations_today = 0
		requested_objects = []

		user.mailbox.conversations.each do |convo|
			if convo.last_message.updated_at > 1.day.ago
				new_conversations_today += 1
				requested_objects.push(convo.subject)
			end
		end
		
		if new_conversations_today > 0
			object_names = requested_objects.uniq.collect! {|obj| Giving.find(obj).name}
			puts "\nSending the email to user...\n"
			UserMailer.send_request_summary_notification(user, new_conversations_today, object_names).deliver_now
		end
	end
end
