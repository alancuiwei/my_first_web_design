#encoding: utf-8

class ContactusController < ApplicationController

  def companyintro
    @pagetitle="公司介绍"
  end

  def personintro
    @pagetitle="公司员工"
  end

  def productintro
    @pagetitle="产品介绍"
  end

  def hire
    @pagetitle="招聘信息"
  end

  def cuiweiintro
    @pagetitle="公司人员"
  end

  def wukangintro
    @pagetitle="公司人员"
  end
end
