class AddHeadersToRequest < ActiveRecord::Migration[5.0]
  def change
  	add_column :requests, :headers, :text
  end
end
