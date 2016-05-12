case @environment
when 'production'
	every 2.minutes do
		runner "Transfer.send_notifications", output: {:error => "#{path}/log/error.log", :standard => "#{path}/log/cron.log"}
	end
end"