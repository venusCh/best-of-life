class Transfer < ActiveRecord::Base
	belongs_to :giving

	# Summary emails that get sent end of day at certain time
	def self.send_notifications

		puts "\ninside ApplicationHelper::send_notifications\n"

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

	# reminder emails when the due date is approaching
	def self.send_reminders

		puts "\ninside ApplicationHelper::send_reminders\n"
		@activeTransfers = Transfer.find_by_is_active(true)

		@activeTransfers.all.each do |transfer|
			puts "\ninside ApplicationHelper::looping through active transfers\n"
			today = Time.now.to_date
			due_date = transfer.due_date.to_date

			object = Giving.find_by_id(transfer.giving_id)
			user = User.find_by_id(transfer.to_id)

			puts "\nSending the email to user...\n"
			if (today == due_date)
				UserMailer.send_lastday_reminder(user, object, transfer).deliver_now
			elsif (today > due_date)
				if ((today - due_date) % 4 == 0) # remind every 4 days if overdue
					UserMailer.send_overdue_reminder(user, object, transfer).deliver_now
				end
			elsif (7.days.from_now == due_date)
				UserMailer.send_7day_reminder(user, object, transfer).deliver_now
			end
		end
	end

	# send emails when items in their wishlist become available
	def self.send_wishlist_reminders

		puts "\ninside ApplicationHelper::send_reminders\n"

		User.all.each do |user|
			puts "\ninside ApplicationHelper::looping through users\n"		

			today = Time.now.to_date
			wishlist = user.find_up_voted_items

			wishlist.each do |item|
				if (item.status == 0 && # available
					item.updated_at.to_date == today)
					UserMailer.send_wishlist_item_available(user, item).deliver_now
				end
			end
		end
	end

end
