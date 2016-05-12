#set :output, "#{path}/log/cron.log"

#every :day, :at => '5:00pm' do
#	rake "send_digest_email"
#end

every 2.minutes do
	runner "Transfer.send_notifications", output: {:error => '#{path}/log/error.log', :standard => '#{path}/log/cron.log'}
end

# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end
