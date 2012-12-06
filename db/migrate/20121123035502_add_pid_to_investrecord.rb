class AddPidToInvestrecord < ActiveRecord::Migration
  def change
    add_column :investrecord, :pid, :integer #新增一栏
  end
end
