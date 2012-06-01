
class HomeController < ApplicationController
  def index
    @versions=Versionstable.find(:all, :order =>"update_date DESC",:limit => 3)
    @versions_all=Versionstable.find(:all, :order =>"update_date DESC")
  end
  def comingsoon
  end
end
