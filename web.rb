require 'mail'
require 'pp'
require 'sinatra'
require 'twitter'

require_relative 'helpers'

$stdout.sync = $stderr.sync = true

TOM_EMAIL = ENV.fetch("TOM_EMAIL")
MAILING_LISTS = ENV.fetch("MAILING_LISTS").split(',')
USERNAME = ENV.fetch("USERNAME")
PASSWORD = ENV.fetch("PASSWORD")

MAX_LEN = ENV.fetch("MAX_TWEET_LENGTH", 280)

twitter = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV.fetch('TWITTER_CONSUMER_KEY')
  config.consumer_secret     = ENV.fetch('TWITTER_CONSUMER_SECRET')
  config.access_token        = ENV.fetch('TWITTER_ACCESS_TOKEN')
  config.access_token_secret = ENV.fetch('TWITTER_ACCESS_TOKEN_SECRET')
end

use Rack::Auth::Basic do |username, password|
  username == USERNAME && password == PASSWORD
end

post '/messages' do
  message = JSON.parse(request.body.read)
  puts "received message:"
  pp message
  headers = message['headers']
  if headers
    from = headers.fetch('From', '')
    list = headers.fetch('List-Id', '')
    if from.include?(TOM_EMAIL) && MAILING_LISTS.any? { |l| list.include?(l) }
      # TODO: check for html with fallback to plain just in case hell
      # freezes over and Tom starts sending html e-mail
      body = message['plain']
      last_sentence = find_last_sentence(body)
      if last_sentence
        len = last_sentence.length
        if len <= MAX_LEN
          puts "tweeting last sentence (#{len} chars)"
          twitter.update(last_sentence)
          status 201
        else
          puts "last sentence too long (#{len} chars; max is #{MAX_LEN}); skipping"
        end
      else
        puts "could not extract last sentence"
      end
    end
  end
end

post '/debug' do
  puts "received message:"
  pp params
end
