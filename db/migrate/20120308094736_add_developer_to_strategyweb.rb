class AddDeveloperToStrategyweb < ActiveRecord::Migration
  def self.up
	add_column :strategyweb,:developer,:string
  end
  def self.down
	remove_column :strategyweb,:developer
  end
end
