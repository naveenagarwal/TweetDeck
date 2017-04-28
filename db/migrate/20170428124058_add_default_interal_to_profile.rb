class AddDefaultInteralToProfile < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :default_interval, :integer
    add_column :profiles, :default_interval_type, :string
  end
end
