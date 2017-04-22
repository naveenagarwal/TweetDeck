class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles do |t|
      t.string :provider
      t.string :token
      t.string :secret
      t.string :access_token
      t.string :uid
      t.string :name
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
