#encoding: utf-8
class HomeController < ApplicationController
  def index
    #UserMailer.forgetpassword("feifan_5223@163.com",1,1).deliver
    @versions=Versionstable.find(:all, :order =>"update_date DESC",:limit => 3)
    @versions_all=Versionstable.find(:all, :order =>"update_date DESC")
  end

  def comingsoon
  end
end
