class AddActualValueToTests < ActiveRecord::Migration[5.0]
  def change
  	add_column :tests, :actual_value, :text
  end
end
