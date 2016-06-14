desc "Fetch and stream all the tweets for current users"
task :timeline_watcher => :environment do
  TimelineWatcher.new(logger: Rails.logger).perform_in_foreground
end
