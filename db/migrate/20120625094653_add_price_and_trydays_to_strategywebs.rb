class AddPriceAndTrydaysToStrategywebs < ActiveRecord::Migration
  def change
    add_column :strategyweb, :price, :double
    add_column :strategyweb, :trydays, :double
  end
end
