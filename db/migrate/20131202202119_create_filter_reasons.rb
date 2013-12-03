class CreateFilterReasons < ActiveRecord::Migration
  def change
    create_table :filter_reasons do |t|
      t.string :for_resource
      t.string :short_description

      t.timestamps
    end
  end
end
