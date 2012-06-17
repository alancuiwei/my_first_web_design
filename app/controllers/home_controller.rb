
class HomeController < ApplicationController
  def index
    @versions=Versionstable.find(:all, :order =>"update_date DESC",:limit => 3)
    @versions_all=Versionstable.find(:all, :order =>"update_date DESC")
    @strategyweb=Strategyweb.find(:all, :order =>"updated_at DESC",:limit => 3)
    @strategyweb_all=Strategyweb.find(:all, :order =>"updated_at DESC")
  end
  def comingsoon
  end
end
