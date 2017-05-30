class CreateSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :settings do |t|
      ## Database authenticatable
      t.string :key, null: false
      t.text :value, null: false
      t.timestamps
    end
  end
end
