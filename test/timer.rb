require 'rubygems'
require 'rufus/scheduler'
scheduler = Rufus::Scheduler.start_new

scheduler.every("2s") do
   puts Time.now
end