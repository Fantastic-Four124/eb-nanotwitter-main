require 'sinatra'
require 'byebug'
require 'time_difference'
require 'time'
require 'redis'
require 'sinatra/cors'
require 'uri'
require 'securerandom'
require 'bunny'
require 'json'
require 'rest-client'


configure do
#  REDISTOGO_URL = "redis://localhost:6379/"
  PUBLIC_REDIS_URL = 'redis://rediscloud:FEtS3Muv7bSjHnOIqfK2hycHfxUm5qIG@redis-15517.c14.us-east-1-3.ec2.cloud.redislabs.com:15517'
#  MY_REDIS_URL = 'redis://h:p9dd6b325e2530743e01f5b5c7b639bcff92827007e3f590e2015c2af0cc9edc9@ec2-35-173-148-122.compute-1.amazonaws.com:23559'
  uri = URI.parse(PUBLIC_REDIS_URL)
  $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  PREFIX = 'api/v1'
  TWEET_SERVICE_URL = 'https://boiling-castle-61613.herokuapp.com'
  TWEETS = 'tweets'
  RECENT = 'recent'
end

enable :sessions

set :allow_origin, '*'
set :allow_methods, 'GET,HEAD,POST'
set :allow_headers, 'accept,content-type,if-modified-since'
set :expose_headers, 'location,link'
set :bind, '0.0.0.0' # Needed to work with Vagrant


# Small helper that minimizes code
helpers do
  def protected! token
    return !$redis.get(token).nil?
  end
end

# For loader.io to auth
get '/loaderio-5026e65eed1dbb67971ba6671d1760fe.txt' do
  send_file 'loaderio-5026e65eed1dbb67971ba6671d1760fe.txt'
end

get '/' do
  render :html, :index
end

get '/78cc6f9c2e98cf61/bundle.js' do
  send_file '78cc6f9c2e98cf61/bundle.js'
end

get '/bundle.js' do
  send_file 'bundle.js'
end

post '/users/register' do
end

post '/login' do
end

post '/:token/logout' do
end

get '/:token/users/:id' do
end

post '/:token/users/:id/follow' do
end

post '/:token/users/:id/unfollow' do
end

get '/:token/users/:id/leader-list' do
end

get '/:token/users/:id/follower-list' do
end

post '/:token/tweets/new' do
end

get '/tweets/recent' do
  url = TWEET_SERVICE_URL + '/' + PREFIX + '/' + TWEETS + '/' + RECENT
    RestClient.get url, {}
end

get '/:token/users/:id/timeline' do
end

get '/:token/users/:id/feed' do
end

