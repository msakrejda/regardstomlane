require 'mail'
require 'pp'
require 'sinatra'
require 'twitter'

require_relative 'helpers'

$stdout.sync = $stderr.sync = true

MAILING_LISTS = ENV.fetch("MAILING_LISTS").split(',')
USERNAME = ENV.fetch("USERNAME")
PASSWORD = ENV.fetch("PASSWORD")

TARGETS = {}

# Allow configuring multiple Tom-like accounts, by adding them with as TOM_EMAIL_1, TOM_EMAIL_2, and so on
# Note that each of these also needs their own twitter tokens, i.e. TWITTER_CONSUMER_KEY_1, etc
def add_target(suffix)
  return unless ENV['TOM_EMAIL' + suffix].present?
  tom_email = ENV.fetch('TOM_EMAIL' + suffix)
  TARGETS[tom_email] = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV.fetch('TWITTER_CONSUMER_KEY' + suffix)
    config.consumer_secret     = ENV.fetch('TWITTER_CONSUMER_SECRET' + suffix)
    config.access_token        = ENV.fetch('TWITTER_ACCESS_TOKEN' + suffix)
    config.access_token_secret = ENV.fetch('TWITTER_ACCESS_TOKEN_SECRET' + suffix)
  end
end

add_target('')
(1..10).each { |i| add_target('_' + i.to_s) }

MAX_LEN = 140

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
    list = headers.fetch('List-ID', '')
    TARGETS.each do |email, twitter|
      next unless from.include?(email) && MAILING_LISTS.any? { |l| list.include?(l) }

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
