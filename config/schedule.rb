case @environment
when 'production'
	every "0 6,18 * * *" do
		puts "\n\ncalling Transfer.send_notifications...\n"
		command 'cd /var/app/current && rails runner -e production \"Transfer.send_notifications\"'
	end
end
