class TwitterWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(post_id, profile_id)
    post = Post.find(post_id)
    return if post.drafted?

    profile = Profile.find(profile_id)
    client = Postman::TwitterDeck.new
    serialized_content = PostSeralizer.new(post, 'twitter').serialized_content

    if post.ready?
      tweet_ids = []
      serialized_content.each do |content|
        time = Time.now
        tweeted = client.post_tweet(content, profile)
        status, sent_at = tweeted[:status] == false ? [tweeted[:error], nil]
          : ["Tweeted", time]

        post.update(status: status, sent_at: sent_at, state: "tweeted")
        tweet_ids << tweeted[:tweet_id]
      end
      post.update(tweet_ids: tweet_ids.join(","))

    elsif post.tweeted?
      post.tweet_ids.split(",").each do |tweet_id|
        client.retweet(tweet_id, profile)
      end
      post.update(status: "Retweeted", retweeted_at: Time.now, state: "retweeted")
    end

  end

end