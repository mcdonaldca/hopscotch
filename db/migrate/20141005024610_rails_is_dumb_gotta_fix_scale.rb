class RailsIsDumbGottaFixScale < ActiveRecord::Migration
  def change
  	remove_column :users, :latest_bac
  	add_column :users, :latest_bac, :decimal, :default => 0.0, precision: 3, scale: 2
  end
end
