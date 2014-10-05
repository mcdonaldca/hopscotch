class RepairCurrentHopSituation < ActiveRecord::Migration
  def change
  	remove_column :users, :current_hop
  	add_column :users, :current_hop, :integer, :default => nil
  end
end
