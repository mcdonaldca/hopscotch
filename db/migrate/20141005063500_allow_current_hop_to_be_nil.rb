class AllowCurrentHopToBeNil < ActiveRecord::Migration
  def change
  	change_column :users, :current_hop, :integer, :null => true, :default => nil
  end
end
