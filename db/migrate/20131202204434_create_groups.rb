class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :title
      t.string :logo
      t.string :description
      t.string :owner

      t.timestamps
    end
  end
end
