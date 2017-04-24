class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.text :content
      t.string :state
      t.datetime :sent_at
      t.text :status
      t.text :job_id
      t.text :queue_name
      t.references :profile, index: true
      t.references :document, index: true
      t.datetime :deleted_at
      t.text :tweet_ids
      t.datetime :retweeted_at
      t.references :user, index: true, foreign_key: true

      t.timestamps
    end
  end
end
