class AddSessionsTable < ActiveRecord::Migration
  def up
    create_table :session do |t|
      t.string :session_id, :null => false
      t.text :data , :null => false
      t.timestamps
    end

    add_index :session, :session_id
    add_index :session, :updated_at
  end

  def down
    drop_table :session
  end
end
