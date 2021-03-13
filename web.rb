require 'mail'
require 'pp'
require 'sinatra'
require 'twitter'

require 'openssl'

require_relative 'helpers'

$stdout.sync = $stderr.sync = true

TOM_EMAIL = ENV.fetch("TOM_EMAIL")
MAILING_LISTS = ENV.fetch("MAILING_LISTS").split(',')

MAX_LEN = ENV.fetch("MAX_TWEET_LENGTH", 280)

twitter = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV.fetch('TWITTER_CONSUMER_KEY')
  config.consumer_secret     = ENV.fetch('TWITTER_CONSUMER_SECRET')
  config.access_token        = ENV.fetch('TWITTER_ACCESS_TOKEN')
  config.access_token_secret = ENV.fetch('TWITTER_ACCESS_TOKEN_SECRET')
end

def verify_msg(token, timestamp, signature)
  signing_key = ENV.fetch('MAILGUN_API_KEY')
  digest = OpenSSL::Digest::SHA256.new
  data = [timestamp, token].join
  signature == OpenSSL::HMAC.hexdigest(digest, signing_key, data)
end

post '/messages' do
  token = params.fetch('token')
  timestamp = params.fetch('timestamp')
  signature = params.fetch('signature')
  verified = verify_msg(token, timestamp, signature)
  unless verified
    halt 401
  end

  puts "received message:"
  pp params

  from = params.fetch('from')
  headers = Hash[JSON.parse(params.fetch('message-headers'))]
  list = headers['List-Id']

  if from.include?(TOM_EMAIL) && !list.nil? && MAILING_LISTS.any? { |l| list.include?(l) }
    body = params.fetch('body-plain')
    last_sentence = find_last_sentence(body)
    if last_sentence
      len = last_sentence.length
      if len <= MAX_LEN
        puts "tweeting last sentence (#{len} chars)"
        twitter.update(last_sentence)
        status 200
      else
        puts "last sentence too long (#{len} chars; max is #{MAX_LEN}); skipping"
      end
    else
      puts "could not extract last sentence"
    end
  end
end

post '/debug' do
  puts "received message:"
  puts params

  token = params.fetch('token')
  timestamp = params.fetch('timestamp')
  signature = params.fetch('signature')
  verified = verify_msg(token, timestamp, signature)
  puts "message verifies: #{verified}"

  puts "from: #{params.fetch('from')}"
  headers = Hash[JSON.parse(params.fetch('message-headers'))]
  puts headers
  list = headers['List-Id']
  puts "list is: #{list}"
  body = params.fetch('body-plain')
  puts "body is: #{body}"

  status 200
end
