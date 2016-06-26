case @environment
when 'production'
	every "0 10,22 * * *" do #Amzaon server follows GMT (-4 hours) time
		puts "\n\ncalling Transfer.send_notifications...\n"
		command 'cd /var/app/current && rails runner -e production "Transfer.send_notifications"'
	end
	every "0 12 * * *" do 
		puts "\n\ncalling Transfer.send_reminders...\n"
		command 'cd /var/app/current && rails runner -e production "Transfer.send_reminders"'
	end		
	every "0 24 * * *" do 
		puts "\n\ncalling Transfer.send_wishlist_reminders...\n"
		command 'cd /var/app/current && rails runner -e production "Transfer.send_wishlist_reminders"'
	end		
end
