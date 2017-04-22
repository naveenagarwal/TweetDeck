TWITTER_KEY = ENV['TWITTER_KEY']
TWITTER_SECRET = ENV['TWITTER_SECRET']
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, TWITTER_KEY, TWITTER_SECRET,
    {
      :secure_image_url => 'true',
      :image_size => 'original',
      :authorize_params => {
        :force_login => 'true',
        :lang => 'en'
      }
    }
end