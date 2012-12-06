class AddDescriptionsToProduct < ActiveRecord::Migration
  def change
    add_column :product, :descriptions, :text
  end
end
