class ChangePnamePidToInvestrecord < ActiveRecord::Migration
  def change
    change_column(:investrecord, :pid, :string)
    rename_column(:investrecord, :pid, :pname)

  end
end
