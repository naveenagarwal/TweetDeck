class AddScheduledAtToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :scheduled_at, :datetime, index: true
  end
end
