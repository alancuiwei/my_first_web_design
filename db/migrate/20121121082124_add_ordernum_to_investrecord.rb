class AddOrdernumToInvestrecord < ActiveRecord::Migration
  def change
    add_column :investrecord, :ordernum, :integer #新增一栏
  end
end
