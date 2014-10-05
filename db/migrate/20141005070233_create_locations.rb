class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :registration_id
      t.string :time, :default => nil

      t.timestamps
    end
  end
end
