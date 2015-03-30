# require 'sinatra'
require 'pry'
# require 'sinatra/reloader'
require 'fitgem'
require 'dotenv'
require 'chronic'

Dotenv.load

class UserLoader
  # Fitgem client docs: http://www.rubydoc.info/gems/fitbit/0.2.0/Fitbit/Client#activities_on_date-instance_method

  def initialize
    @consumer_key = ENV['FITBIT_CONSUMER_KEY']
    @consumer_secret = ENV['FITBIT_CONSUMER_SECRET']
  end
  # Gets access to client

  def oauth_access
    client = Fitgem::Client.new({:consumer_key => @consumer_key, :consumer_secret => @consumer_secret})

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

    client = Fitgem::Client.new({:consumer_key => @consumer_key, :consumer_secret => @consumer_secret, :token => token, :secret => secret, :user_id => user_id})
    access_token = client.reconnect(token, secret)
    # Pass client to runner here
    client
  end

  def time_not_moving(timeframe, client)
    parsed_timeframe = Chronic.parse(timeframe)
    activity = client.data_by_time_range('/activities/log/minutesSedentary', { base_date: parsed_timeframe, end_date: Time.now })
    # Returns value of current activity level
    activity["activities-log-minutesSedentary"].first["value"]
  end
end
