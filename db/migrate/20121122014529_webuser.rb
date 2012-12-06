class Webuser < ActiveRecord::Migration
  def change
    create_table :webuser do |t|
      t.string :username
      t.string :password
      t.string :tel
      t.text :address
      t.string :postcode
      t.float :period
      t.float :returnrate

      t.timestamps
    end
  end
end
