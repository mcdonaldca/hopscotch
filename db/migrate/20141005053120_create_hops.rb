class CreateHops < ActiveRecord::Migration
  def change
  	add_column :users, :hop_id, :integer, :default => nil

    create_table :hops do |t|
    	t.string :code
    	t.boolean :planned
      t.timestamps
    end
  end
end
