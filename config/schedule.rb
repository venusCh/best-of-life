case @environment
when 'production'
	every "0 10,22 * * *" do #Amzaon server follows GMT (-4 hours) time
		puts "\n\ncalling Transfer.send_notifications...\n"
		command 'cd /var/app/current && rails runner -e production "Transfer.send_notifications"'
	end
end
