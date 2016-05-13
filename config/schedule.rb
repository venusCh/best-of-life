case @environment
when 'production'
	#every "0 6,18 * * *" do
	every 2.minutes do
		puts "\n\nabout to call Transfer.send_notifications...\n"
		runner "Transfer.send_notifications" #, output: {:error => "#{path}/log/error.log", :standard => "#{path}/log/cron.log"}
	end
end