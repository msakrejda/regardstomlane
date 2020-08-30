require 'json'
require './vendor/twitter'

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

def lambda_handler(event:, context:)
  msg_id = get_msg_id(event)
  if !relevant?(event)
    { statusCode: 200, body: JSON.generate({ message: "ignored #{msg_id}" }) }
  end

  tweets = extract_tweets(event)
  tweets.each do |tweet|
    twitter.update(tweet)
  end
  { statusCode: 200, body: JSON.generate({ message: "processed #{msg_id}" }) }
end

def get_msg_id(event)
  event['Records'].map do |record|
    record.dig('ses', 'mail', 'commonHeaders', 'messageId')
  end.compact.join(';')
end

def relevant?(event)
  event['Records'].any? do |record|
    relevant_record?(record)
  end
end

def relevant_record?(event_record)
  headers = event_record.dig('ses', 'mail', 'headers')
  from = headers&.find { |header| header['name'] == 'From' }&.fetch('value') || ''
  list = headers&.find { |header| header['name'] == 'List-Id' }&.fetch('value') || ''
  from.include?(TOM_EMAIL) && MAILING_LISTS.any? { |l| list.include?(l) }
end

def extract_tweets(event)
  records = event['Records'].select { |r| relevant_record?(r) }
  records.map do |record|
    email_body = 
  end
end