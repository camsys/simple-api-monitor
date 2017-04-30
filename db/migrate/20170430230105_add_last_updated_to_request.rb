class AddLastUpdatedToRequest < ActiveRecord::Migration[5.0]
  def change
  	add_column :requests, :last_updated, :datetime
  end
end
