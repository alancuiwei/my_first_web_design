class CreateWebuserstrategy < ActiveRecord::Migration
  def change
    create_table :webuserstrategy do |t|
      t.string :username
      t.string :strategyid
      t.string :paraname
      t.float :paravalue

      t.timestamps
    end
  end
end
