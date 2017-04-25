class HomeController < ApplicationController
  def index
    @stats = get_posts_stats
  end

  private

  def get_posts_stats
    stats = {}
    [:drafted, :ready, :tweeted, :retweeted].each do |state|
      stats[state] = current_user.posts.where(state: state.to_s).count
    end
    stats[:imported_posts] = current_user.posts.where("document_id IS NOT NULL").count
    stats
  end
end
