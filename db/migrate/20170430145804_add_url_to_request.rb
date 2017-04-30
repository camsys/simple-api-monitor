class AddUrlToRequest < ActiveRecord::Migration[5.0]
  def change
  	add_column :requests, :url, :string, default: false
  	add_column :requests, :name, :string, default: false
  end
end
