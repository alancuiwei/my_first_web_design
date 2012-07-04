class CreatSubscribetable < ActiveRecord::Migration
  def change
      create_table :subscribetable do |s|
        s.string :subscribeid
        s.string :strategyid
        s.integer :ordernum
        s.integer :strategy_userid
        s.integer :subscribe_userid
        s.float :price
        s.float :subscribedays
        s.datetime :subscribedate
        s.timestamps
      end
  end
end
