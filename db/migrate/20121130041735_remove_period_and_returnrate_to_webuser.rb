class RemovePeriodAndReturnrateToWebuser < ActiveRecord::Migration
  def change
    remove_column(:webuser ,:period)
    remove_column(:webuser ,:returnrate)
  end
end
