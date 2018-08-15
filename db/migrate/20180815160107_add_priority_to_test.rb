class AddPriorityToTest < ActiveRecord::Migration[5.0]
  def change
    add_column :tests, :priority, :integer, null: false, default: 0
  end
end
