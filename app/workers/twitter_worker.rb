class TwitterWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  # TODO - refactor to make this IO efficent. Bring in Threading

  def perform(post_id, profile_id)
    post = Post.find(post_id)
    return if post.drafted?
    begin
      profile = Profile.find(profile_id)
      client = Postman::TwitterDeck.new
      serialized_content = PostSeralizer.new(post, 'twitter').serialized_content

      if post.ready?
        tweet_ids = []
        options = {}
        if post.media.exists?
          media_ids = post.media.map do |media|
            Thread.new do
              client.upload(File.new(media.upload_doc.file.file), profile)
            end
          end.map(&:value)
          options = { media_ids: media_ids.join(",")}
        end
        logger.info "Media ids - #{media_ids}"
        post.update(media_ids: options[:media_ids])
        serialized_content.each do |content|
          time = Time.now
          tweeted = client.post_tweet(content, profile, options)
          status, sent_at = tweeted[:status] == false ? [tweeted[:error], nil]
            : ["Tweeted", time]

          post.update(status: status, sent_at: sent_at, state: "tweeted")
          tweet_ids << tweeted[:tweet_id]
          #reset the media_ids
          options = {}
        end
        # save the tweet ids to retweet it later
        post.update(tweet_ids: tweet_ids.join(","))

      elsif post.tweeted?
        post.tweet_ids.split(",").each do |tweet_id|
          client.retweet(tweet_id, profile)
        end
        post.update(status: "Retweeted", retweeted_at: Time.now, state: "retweeted")
      end
    rescue Exception => e
      post.update(status: e.message)
      logger.error "Error in processing post #{post.id} - #{e.message}\n#{e.backtrace}"
    end

  end

end