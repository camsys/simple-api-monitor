class AddUseSslToRequest < ActiveRecord::Migration[5.0]
  def change
  	add_column :requests, :use_ssl, :boolean, default: false
  end
end
