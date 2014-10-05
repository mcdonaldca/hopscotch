class AddBoozeLevel < ActiveRecord::Migration
  def change
  	add_column :users, :booze_level, :integer, :default => 0
  end
end
