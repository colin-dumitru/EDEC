class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.integer :filter_reason_if
      t.string :item_id
      t.timestamps
    end
  end
end
