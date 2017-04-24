class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :documents do |t|
      t.string :upload_doc
      t.string :resource_type
      t.string :status
      t.string :records_processed
      t.string :posts_added
      t.string :posts_rejected
      t.string :job_id
      t.string :queue_name
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
