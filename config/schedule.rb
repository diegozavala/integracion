# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :environment, "development"

every 10.minutes do
  runner "Home.test_ftp"
end


every 2.hours do
  runner "Home.test_dropbox"
end

every 2.hours do
  runner "Home.get_reposicion"
end

every 5.hours do
  runner "Offer.check_inactive"
end

every 5.hours do
  runner "Offer.check_active"
end