class CreateMedia < ActiveRecord::Migration[5.0]
  def change
    create_table :media do |t|
      t.string :upload_doc
      t.references :post, foreign_key: true

      t.timestamps
    end
  end
end
