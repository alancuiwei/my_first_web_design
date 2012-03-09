class AddStrategyattrToStrategyweb < ActiveRecord::Migration
  def self.up
	add_column :strategyweb,:strategyattr,:string
  end
  def self.down
	remove_column :strategyweb,:strategyattr
  end

end
