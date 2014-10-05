class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :username
      t.string :email
      t.string :password
      t.string :first
      t.string :last
      t.string :phone
      t.string :bactrack_id, :default => ''

      t.timestamps
    end
  end
end
