# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#

job_type :rbenv_rake, 'export PATH="$HOME/.rbenv/bin:$PATH"; eval "$(rbenv init -)"; 
                           cd :path && bundle exec rake :task --silent :output'

set :output, "~/cron_log.log"

every 15.minutes do
  rbenv_rake "input:collect"
end

