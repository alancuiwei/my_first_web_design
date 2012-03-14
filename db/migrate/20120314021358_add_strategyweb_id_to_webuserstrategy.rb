class AddStrategywebIdToWebuserstrategy < ActiveRecord::Migration
  def self.up
	add_column :webuserstrategy, :strategyweb_id, :integer
  end
  def self.down
	remove_column :webuserstrategy, :strategyweb_id
  end
end
