class CreateUsercommodityT < ActiveRecord::Migration
  def change
    create_table :usercommodity_t do |t|
      t.float :tardecharge

      t.timestamps
    end
  end
end
