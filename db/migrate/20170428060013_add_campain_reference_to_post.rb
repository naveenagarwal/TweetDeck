class AddCampainReferenceToPost < ActiveRecord::Migration[5.0]
  def change
    add_reference :posts, :campaign #, foreign_key: true
  end
end
