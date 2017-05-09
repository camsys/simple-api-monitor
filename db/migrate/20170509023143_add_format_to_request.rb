class AddFormatToRequest < ActiveRecord::Migration[5.0]
  def change
  	add_column :requests, :format, :string, default: "json"
  end
end
