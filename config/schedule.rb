case @environment
when 'production'
	every 1.day, :at => '5:00 pm' do
		runner "Transfer.send_notifications", output: {:error => "#{path}/log/error.log", :standard => "#{path}/log/cron.log"}
	end
end