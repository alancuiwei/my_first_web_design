class AddPredividendToProductrecord < ActiveRecord::Migration
  def change
    add_column(:productrecord, :predividend, :float)
  end
end
