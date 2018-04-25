# bind "unix:///var/run/puma/my_app.sock"
# pidfile "/var/run/puma/my_app.sock"

require 'connection_pool'
workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 10)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

tweet_uri = URI.parse(ENV["TWEET_REDIS_URL"])
tweet_uri_spare = URI.parse(ENV['TWEET_REDIS_SPARE_URL'])
$tweet_redis = ConnectionPool.new(size: 10) { Redis.new(:host => tweet_uri.host, :port => tweet_uri.port, :password => tweet_uri.password) }
$tweet_redis_spare = ConnectionPool.new(size: 10) { Redis.new(:host => tweet_uri_spare.host, :port => tweet_uri_spare.port, :password => tweet_uri_spare.password) }

on_worker_boot do
  $bundle = File.read('bundle.js')
#  tweet_uri = URI.parse(ENV["TWEET_REDIS_URL"])
#  tweet_uri_spare = URI.parse(ENV['TWEET_REDIS_SPARE_URL'])
#  $tweet_redis = Redis.new(:host => tweet_uri.host, :port => tweet_uri.port, :password => tweet_uri.password)
#  $tweet_redis_spare = Redis.new(:host => tweet_uri_spare.host, :port => tweet_uri_spare.port, :password => tweet_uri_spare.password)
end
