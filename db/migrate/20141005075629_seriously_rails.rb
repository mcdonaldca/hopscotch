class SeriouslyRails < ActiveRecord::Migration
  def change
  	add_column :users, :wtf, :integer, :default => nil
  end
end
