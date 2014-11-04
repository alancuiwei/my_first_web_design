class AddFounddateToProduct < ActiveRecord::Migration
  def change
    add_column :product, :founddate, :date #新增一栏
  end
end
