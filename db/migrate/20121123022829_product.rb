class Product < ActiveRecord::Migration
  def change
    create_table :product do |t|
      t.string :pname
      t.text :description
      t.float :lastprofits
      t.float :todayprofit
      t.date  :date
      t.timestamps
    end
  end
end
