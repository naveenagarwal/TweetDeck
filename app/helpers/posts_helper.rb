module PostsHelper

  def post_states
    [
      ['Drafted', 'drafted'],
      ['Ready', 'ready']
    ]
  end

  def get_class_by_state(state)
    case state
    when "drafted"
      "text-info"
    when "ready"
      "text-success"
    when "retweet_ready"
      "text-success"
    when "tweeted"
      "text-warning"
    when "retweeted"
      "text-danger"
    end
  end

end
