require 'sinatra'
require 'mail'
require_relative 'helpers'

$stdout.sync = $stderr.sync = true

TOM_EMAIL = ENV.fetch("TOM_EMAIL")
PGSQL_HACKERS = ENV.fetch("PGSQL_HACKERS_LIST")
USERNAME = ENV.fetch("USERNAME")
PASSWORD = ENV.fetch("PASSWORD")

MAX_LEN = 144

use Rack::Auth::Basic do |username, password|
  username == USERNAME && password == PASSWORD
end

post '/message' do
  message = JSON.parse(request.body.read)
  puts "received message: #{message}"
  headers = message['headers']
  if headers
    if headers['From'] && headers['From'].include?(TOM_EMAIL) &&
        headers['List-ID'] && headers['List-ID'].include?(PGSQL_HACKERS)
      # TODO: check for html with fallback to plain just in case hell
      # freezes over and Tom starts sending html e-mail
      body = message['plain']
      candidate_tweet = last_sentence(body)
      if candidate_tweet
        if candidate_tweet.length <= MAX_LEN
          puts "*" * 80
          puts "found candidate tweet!"
          puts "\t#{candidate_tweet}"
          puts "extracted from:\n#{body}"
          puts "*" * 80
          status 201
        else
          puts "*" * 80
          puts "last sentence too long!"
          puts "\t#{candidate_tweet}"
          puts "extracted from:\n#{body}"
          puts "*" * 80
        end
      else
        puts "Could not determine last sentence in:\n#{body}"
      end
    end
  end
end
