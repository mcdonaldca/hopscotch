class AddLatestInfoToUser < ActiveRecord::Migration
  def change
  	add_column :users, :latest_bac, :decimal, :default => 0.0, precision: 3
  	add_column :users, :drunk_emoji, :string, :default => "https://abs.twimg.com/emoji/v1/72x72/1f636.png"
  end
end
