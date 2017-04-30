class AddUrlToRequest < ActiveRecord::Migration[5.0]
  def change
  	add_column :requests, :url, :string, null: false
  	add_column :requests, :name, :string, null: false
  end
end
