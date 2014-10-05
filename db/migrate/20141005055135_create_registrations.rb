class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.integer :user_id
      t.integer :hop_id
      t.string :final_destination_lat, :default => nil
      t.string :final_destination_long, :default => nil
      t.boolean :active, :default => true

      t.timestamps
    end
  end
end
