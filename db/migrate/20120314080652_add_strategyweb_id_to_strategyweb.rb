class AddStrategywebIdToStrategyweb < ActiveRecord::Migration
  def self.up
	add_column :strategyweb, :strategyweb_id, :integer
  end
  def self.down
	remove_column :strategyweb, :strategyweb_id
  end
end
