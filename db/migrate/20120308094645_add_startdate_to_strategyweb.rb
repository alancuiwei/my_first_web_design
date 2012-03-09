class AddStartdateToStrategyweb < ActiveRecord::Migration
  def self.up
	add_column :strategyweb,:startdate,:date
  end
  def self.down
	remove_column :strategyweb,:startdate
  end
end
