module Postman
  class TwitterDeck

    def post_tweet(message, profile)
      @client = client(profile)
      begin
        tweet = @client.update(message)
        { status: true, tweet_id: tweet.id }
      rescue Exception => e
        Rails.logger.error "Error in sending tweet for #{profile.uid},#{profile.name} - #{e.to_s}\n#{e.backtrace}"
        { status: false, message: e.message}
      end
    end

    def retweet(tweet_id, profile)
      @client = client(profile)
      begin
        tweet = @client.retweet(tweet_id)
        { status: true }
      rescue Exception => e
        Rails.logger.error "Error in sending tweet for #{profile.uid},#{profile.name} - #{e.to_s}\n#{e.backtrace}"
        { status: false, message: e.message }
      end
    end

    private

    def client(profile)
      Twitter::REST::Client.new do |config|
        config.consumer_key = TWITTER_KEY
        config.consumer_secret = TWITTER_SECRET
        config.access_token  = profile.token
        config.access_token_secret = profile.secret
      end
    end
  end
end