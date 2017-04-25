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
    stats[:imported_posts] = current_user.documents.sum(:posts_added)
    stats[:rejected_posts] = current_user.documents.sum(:posts_rejected)
    stats
  end
end
