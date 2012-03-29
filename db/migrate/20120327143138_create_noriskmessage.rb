class CreateNoriskmessage < ActiveRecord::Migration
  def change
    create_table :noriskmessage do |t|
      t.string :title
      t.text :body
      t.string :name

      t.timestamps
    end
  end
end
