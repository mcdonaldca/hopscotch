class ChangeHopIdToCurrentHop < ActiveRecord::Migration
  def change
  	remove_column :users, :hop_id
  	add_column :users, :current_hop, :integer, :default => nil
  end
end
