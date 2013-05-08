require "travis"
require "rails"

desc "This task is called by the Heroku scheduler add-on"

task :restart_last_build do
  Travis.access_token = "7Rk2r85xMd0m7jK4IrpCuw"
  rails = Travis::Repository.find('sukesh15/checkenrol')
  rails.last_build.restart
end