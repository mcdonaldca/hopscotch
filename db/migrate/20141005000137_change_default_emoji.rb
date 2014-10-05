class ChangeDefaultEmoji < ActiveRecord::Migration
  def change
  	change_column :users, :drunk_emoji, :string, :default => "https://abs.twimg.com/emoji/v1/72x72/1f610.png"
  end
end
