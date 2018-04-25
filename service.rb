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
require 'newrelic_rpm'


configure do
  TEST_INTERFACE_URL = 'https://fierce-garden-41263.herokuapp.com'
  PREFIX = 'api/v1'
  TWEET_SERVICE_URL = 'https://nt-tweet-reader.herokuapp.com'
  TWEETS = 'tweets'
  RECENT = 'recent'
  TIMELINE = 'timeline'
  TEST_USER = 'testuser'
  USERS = 'users'
end

onfigure :production do
 require 'newrelic_rpm'
end

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

get '/loaderio-4cb8e3e2b3bbc621379e0973e4802a54.txt' do
  send_file 'loaderio-4cb8e3e2b3bbc621379e0973e4802a54.txt'
end

get '/loaderio-c1de10acb26fb559a7ee2d14a50fc37f.txt' do
  send_file 'loaderio-c1de10acb26fb559a7ee2d14a50fc37f.txt'
end

get '/' do
  render :html, :index
end

get '/78cc6f9c2e98cf61/bundle.js' do
  send_file '78cc6f9c2e98cf61/bundle.js'
end

get '/bundle.js' do
  $bundle
end

#post '/users/register' do
#end
#
#post '/login' do
#end
#
#post '/:token/logout' do
#end
#
#get '/:token/users/:id' do
#end
#
#post '/:token/users/:id/follow' do
#end
#
#post '/:token/users/:id/unfollow' do
#end
#
#get '/:token/users/:id/leader-list' do
#end
#
#get '/:token/users/:id/follower-list' do
#end
#
#post '/:token/tweets/new' do
#end

#get '/users/:id' do
#  url = TWEET_SERVICE_URL + '/' + PREFIX + '/' + TEST_USER + '/' + USERS + '/' + params['id'] + '/' + TIMELINE
#    RestClient.get url, {}
#end

get '/tweets/recent' do
  $tweet_redis.with do |tweet_redis|
    if tweet_redis.llen("recent") > 0
      if rand(2) == 1
        return tweet_redis.lrange("recent", 0, -1).to_json
      else
        $tweet_redis_spare.with do |tweet_redis_spare|
          return tweet_redis_spare.lrange("recent", 0, -1).to_json
        end
      end
    else
      url = TWEET_SERVICE_URL + '/' + PREFIX + '/' + TWEETS + '/' + RECENT
      return RestClient.get url, {}
    end
    # some redis operations
  end
  {err: true}.to_json
end

#post ''
#end

##get '/:token/users/:id/timeline' do
##end
##
##get '/:token/users/:id/feed' do
##end


# TEST INTERFACE

# Delete everything and recreate testuser
post '/test/reset/all' do
  response = RestClient.post TEST_INTERFACE_URL + '/test/reset/all', ''
  response.body
end

# Load the test seed data
post '/test/reset/standard?' do
  response = RestClient.post TEST_INTERFACE_URL + '/test/reset/standard?', params
  response.body
end

# See that the state is what you expect
get '/test/status' do 
  response = RestClient.get TEST_INTERFACE_URL + '/test/status'
  response.body
end 

# create “u” new users, 10 tweets each
post '/test/users/create?' do 
  response = RestClient.post TEST_INTERFACE_URL + '/test/users/create?', params
  response.body
end

# have testuser tweet “t” times
post '/test/user/:user/tweets?' do  
  response = RestClient.post TEST_INTERFACE_URL + '/test/user/:user/tweets?', params
  response.body
end

# have f users follow testuser
post '/test/user/:user/follows?' do
  response = RestClient.post TEST_INTERFACE_URL + '/test/user/:user/follows?', params
  response.body
end

get '/user/testuser' do
  response = RestClient.get(PREFIX_TWEET_R_SERVICE + "/api/v1/testuser/users/3456/timeline")
  response.body
end

post '/user/testuser/tweet' do
  jsonmsg = { "username": 'testuser', "id": 3456, "time": '', 'tweet-input': 'This is a test tweet!' }
  RestClient.post PREFIX_TWEET_W_SERVICE + '/testing/tweets/new', jsonmsg
end

