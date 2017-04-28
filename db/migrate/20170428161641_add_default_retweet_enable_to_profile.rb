class AddDefaultRetweetEnableToProfile < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :default_retweet_enable, :boolean
  end
end
