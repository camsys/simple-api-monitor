class AddResponsesToRequests < ActiveRecord::Migration[5.0]
  def change
  	add_column :requests, :response_code, :string
  	add_column :requests, :response_body, :text
  end
end
