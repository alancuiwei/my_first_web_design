class AddWebuserIdToWebuser < ActiveRecord::Migration
  def self.up
	add_column :webuser, :webuser_id, :integer
  end
  def self.down
	remove_column :webuser, :webuser_id
  end
end
