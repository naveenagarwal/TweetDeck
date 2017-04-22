json.extract! post, :id, :content, :state, :sent_at, :status, :user_id, :created_at, :updated_at
json.url post_url(post, format: :json)
