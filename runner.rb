require 'rufus-scheduler'
require 'pry'
require 'fitgem'
require_relative 'user_loader'
user_loader = UserLoader.new
@user = user_loader.oauth_access


user_loader.time_not_moving("Today", @user)
binding.pry
sedentary_today = user_loader.time_not_moving("Today", @user)



# scheduler = Rufus::Scheduler.new
#
# # working in CLI, not on script run
# def run_scheduler

  # scheduler.every '3s' do
  #   puts "Test"
# end
