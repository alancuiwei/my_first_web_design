class AddFpIdAndFpDateToWebuser < ActiveRecord::Migration
  def change
    add_column :webuser, :fp_id, :text
    add_column :webuser, :fp_date, :datetime
  end
end
