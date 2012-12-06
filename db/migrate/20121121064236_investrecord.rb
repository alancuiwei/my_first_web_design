class Investrecord < ActiveRecord::Migration
  def change
    create_table :investrecord do |t|
      t.string :username
      t.datetime :date
      t.string :recordtype
      t.decimal :recordvalue
      t.timestamps
    end

  end
end
