class AddDetailsToTest < ActiveRecord::Migration[5.0]
  def change
  	add_column :tests, :name, :string, null: false
  	add_column :tests, :status, :boolean
  	add_column :tests, :key, :text
  	add_column :tests, :value, :text
  	add_reference :tests, :request, index: true, foreign_key: true
  end
end
