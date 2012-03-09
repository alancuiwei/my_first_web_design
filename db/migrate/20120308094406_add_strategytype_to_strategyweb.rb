class AddStrategytypeToStrategyweb < ActiveRecord::Migration
  def self.up
	add_column :strategyweb,:strategytype,:string
  end
  def self.down
	remove_column :strategyweb,:strategytype
  end
end
