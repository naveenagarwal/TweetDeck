module TwitterSeralizer
  module ClassMethods

  end

  module InstanceMethods

    POST_CONTENT_LIMIT = 140
    POST_CONTENT_BREAK_LIMIT = 125
    BREAK_SEQUENCE = "TWITTER_BREAK\r\n"

    def twitter_seralized_content(post)
      post.content.length > POST_CONTENT_LIMIT ? break_content(post) : [ post.content ]
    end

    def break_content(post)
      content = word_wrap(post.content, line_width: POST_CONTENT_BREAK_LIMIT,
        break_sequence: BREAK_SEQUENCE).split(BREAK_SEQUENCE)
      total_breaks = content.length

      content.map.with_index do |string, index|
        "#{string} #{suffix}" % { i: index + 1, n: total_breaks }
      end
    end

    def suffix
      @suffix ||= "(%{i}/%{n})"
    end

    def word_wrap(text, line_width: 80, break_sequence: "\n")
      [text].collect! do |line|
        line.length > line_width ? line.gsub(/(.{1,#{line_width}})(\s+|$)/m, "\\1#{break_sequence}").strip : line
      end * break_sequence
    end

  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end