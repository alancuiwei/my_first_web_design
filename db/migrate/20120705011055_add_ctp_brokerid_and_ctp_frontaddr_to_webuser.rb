class AddCtpBrokeridAndCtpFrontaddrToWebuser < ActiveRecord::Migration
  def change
    add_column :webuser, :ctp_brokerid, :text
    add_column :webuser, :ctp_frontaddr, :text
  end
end
