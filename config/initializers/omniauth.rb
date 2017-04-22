TWITTER_KEY = ENV['TWITTER_KEY'] "cbCzLV067II6ngR6yXEsg8yXR"
TWITTER_SECRET = ENV['TWITTER_SECRET'] "O2N2fsPem90AIvovApZrzY0JbKjkq0zayri4eqFEPZ56PpsZ3O"
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