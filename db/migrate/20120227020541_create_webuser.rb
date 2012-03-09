class CreateWebuser < ActiveRecord::Migration
  def change
    create_table :webuser do |t|
      t.string :name
      t.string :hashed_password
      t.string :salt
      t.string :email

      t.timestamps
    end
  end
end
