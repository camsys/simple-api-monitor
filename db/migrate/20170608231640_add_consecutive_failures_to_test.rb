class AddConsecutiveFailuresToTest < ActiveRecord::Migration[5.0]
  def change
  	add_column :tests, :consecutive_failures, :integer, null: false, default: 0
  end
end
