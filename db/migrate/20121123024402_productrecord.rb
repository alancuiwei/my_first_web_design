class Productrecord < ActiveRecord::Migration
  def change
    create_table :productrecord do |t|
      t.string :pname
      t.float :total
      t.float :yreturnrate
      t.float :allprofits
      t.float :capital
      t.float :lastprofits
      t.float :todayprofit
      t.date  :date
      t.timestamps
    end
  end
end
