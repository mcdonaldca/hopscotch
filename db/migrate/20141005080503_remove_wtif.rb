class RemoveWtif < ActiveRecord::Migration
  def change
  	remove_column :users, :wtf
  end
end
