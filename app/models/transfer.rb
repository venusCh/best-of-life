class Transfer < ActiveRecord::Base
	belongs_to :giving

	# Summary emails that get sent end of day at certain time
	def self.send_notifications

		puts "\ninside ApplicationHelper::send_notifications\n"
		puts User.all

		User.all.each do |user|
			puts "\ninside ApplicationHelper::looping through users\n"		
			new_conversations_today = 0
			requested_objects = []

			user.mailbox.conversations.each do |convo|
				if convo.last_message.updated_at > 1.day.ago
					new_conversations_today += 1
					requested_objects.push(convo.subject)
				end
			end
			
			if new_conversations_today > 0
				object_names = requested_objects.uniq.collect! {|obj| Giving.find_by_id(obj).name}
				puts "\nSending the email to user...\n"
				puts user.name
				UserMailer.send_request_summary_notification(user, new_conversations_today, object_names).deliver_now
			end
		end
	end

end
