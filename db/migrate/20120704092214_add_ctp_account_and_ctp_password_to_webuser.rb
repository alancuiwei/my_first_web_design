class AddCtpAccountAndCtpPasswordToWebuser < ActiveRecord::Migration
  def change
    add_column :webuser, :ctp_account, :text
    add_column :webuser, :ctp_password, :text
  end
end
