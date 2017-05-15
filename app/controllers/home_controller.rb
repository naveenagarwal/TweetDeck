class HomeController < ApplicationController
  def index
    # @stats = get_posts_stats
    content = params[:template].present? ?
        current_user.posts.find_by(id: params[:template]).try(:content) : nil
    @post = Post.new(content: content)
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
