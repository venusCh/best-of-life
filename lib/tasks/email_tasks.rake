require 'task_helpers/application_helper'

desc 'send digest email'
task send_digest_email: :environment do
	::Rails.application.eager_load!
  	ApplicationHelper.send_notifications
end