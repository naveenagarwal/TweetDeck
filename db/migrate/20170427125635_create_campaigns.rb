class CreateCampaigns < ActiveRecord::Migration[5.0]
  def change
    create_table :campaigns do |t|
      t.string :name
      t.datetime :start_at
      t.integer :interval
      t.string :interval_type
      t.string :state, default: "created"
      t.datetime :deleted_at
      t.references :user, foreign_key: true
      t.references :document, foreign_key: true

      t.timestamps
    end
  end
end
