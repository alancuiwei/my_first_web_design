class AddSubidAndSubdateToWebusers < ActiveRecord::Migration
  def change
    add_column :webuser, :subid, :text
    add_column :webuser, :subdate, :datetime
  end
end
