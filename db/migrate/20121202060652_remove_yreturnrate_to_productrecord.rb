class RemoveYreturnrateToProductrecord < ActiveRecord::Migration
  def change
    remove_column(:productrecord , :yreturnrate)
  end
end
