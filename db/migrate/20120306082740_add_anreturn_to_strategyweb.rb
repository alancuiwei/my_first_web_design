class AddAnreturnToStrategyweb < ActiveRecord::Migration
  def self.up
	add_column :strategyweb,:anreturn,:float
  end
  def self.down
	remove_column :strategyweb,:anreturn
  end
end
