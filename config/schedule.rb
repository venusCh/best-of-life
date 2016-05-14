case @environment
when 'production'
	#every "0 6,18 * * *" do
	every 2.minutes do
		puts "\n\ncalling Transfer.send_notifications...\n"
		command "/bin/bash -l -c 'cd /var/app/current && rails runner -e production \"Transfer.send_notifications\"'"
	end
end