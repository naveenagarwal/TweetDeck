class AddCampainReferenceToDocument < ActiveRecord::Migration[5.0]
  def change
    add_reference :documents, :campaign #, foreign_key: true
  end
end
