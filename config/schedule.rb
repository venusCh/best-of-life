case @environment
when 'production'
	every "0 6,18 * * *" do
		runner "Transfer.send_notifications", output: {:error => "#{path}/log/error.log", :standard => "#{path}/log/cron.log"}
	end
end