json.extract! campaign, :id, :name, :start_at, :interval, :interval_type, :user_id, :document_id, :created_at, :updated_at
json.url campaign_url(campaign, format: :json)
