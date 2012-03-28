class AddEplaceToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :eplace, :string

    add_column :documents, :dlevel, :integer

  end
  add_index :documents, :id,                :unique => true
end