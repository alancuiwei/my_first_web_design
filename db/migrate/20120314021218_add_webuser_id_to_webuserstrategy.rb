class AddWebuserIdToWebuserstrategy < ActiveRecord::Migration
  def self.up
	add_column :webuserstrategy, :webuser_id, :integer
  end
  def self.down
	remove_column :webuserstrategy, :webuser_id
  end
end
