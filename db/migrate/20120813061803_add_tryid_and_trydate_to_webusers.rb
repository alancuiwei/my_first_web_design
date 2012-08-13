class AddTryidAndTrydateToWebusers < ActiveRecord::Migration
  def change
    add_column :webuser, :tryid, :text
    add_column :webuser, :trydate, :datetime
  end
end
