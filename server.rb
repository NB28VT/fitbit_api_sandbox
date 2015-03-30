# require 'sinatra'
require 'pry'
# require 'sinatra/reloader'
require 'fitgem'
require 'chronic'
# require 'HTTParty'
require 'dotenv'
Dotenv.load

# Fitgem client docs: http://www.rubydoc.info/gems/fitbit/0.2.0/Fitbit/Client#activities_on_date-instance_method

consumer_key = ENV['FITBIT_CONSUMER_KEY']
consumer_secret = ENV['FIBIT_CONSUMER_SECRET']

# Gets access to client

client = Fitgem::Client.new({:consumer_key => consumer_key, :consumer_secret => consumer_secret})

request_token = client.request_token
token = request_token.token
secret = request_token.secret

puts "Go to http://www.fitbit.com/oauth/authorize?oauth_token=#{token} and then enter the verifier code below and hit Enter"
verifier = gets.chomp

access_token = client.authorize(token, secret, { :oauth_verifier => verifier })

puts "Verifier is: "+verifier
puts "Token is:    "+access_token.token
puts "Secret is:   "+access_token.secret

token = access_token.token
secret = access_token.secret
user_id = '3B8C8S'

@client = Fitgem::Client.new({:consumer_key => consumer_key, :consumer_secret => consumer_secret, :token => token, :secret => secret, :user_id => user_id})
access_token = client.reconnect(token, secret)
p @client.user_info



def time_not_moving(timeframe)
  parsed_timeframe = Chronic.parse(timeframe)
  response = @client.data_by_time_range('/activities/log/minutesSedentary', { base_date: parsed_timeframe, end_date: Time.now })
end


binding.pry
