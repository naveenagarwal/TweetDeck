module Postman
  class TwitterDeck

    def post_tweet(message, profile, options={})
      @client = client(profile)
      begin
        tweet = @client.update(message, options)
        { status: true, tweet_id: tweet.id }
      rescue Exception => e
        Rails.logger.error "Error in sending tweet for #{profile.uid},#{profile.name} - #{e.to_s}\n#{e.backtrace}"
        { status: false, error: e.message}
      end
    end

    def retweet(tweet_id, profile)
      @client = client(profile)
      begin
        tweet = @client.retweet(tweet_id)
      rescue Exception => e
        Rails.logger.error "Error in reteeting tweet for #{profile.uid},#{profile.name}, tweet id #{tweet_id} - #{e.to_s}\n#{e.backtrace}"
      end
    end

    def upload(file, profile)
      @client = client(profile)
      @client.upload(file)
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