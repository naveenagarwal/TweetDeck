class PostSeralizer

  include TwitterSeralizer

  attr_accessor :post, :serialzie_for

  def initialize(post, serialzie_for)
    @post = post
    @serialzie_for = serialzie_for
  end

  def serialized_content
    @serialized_content ||= send("#{serialzie_for}_seralized_content", post)
  end

end