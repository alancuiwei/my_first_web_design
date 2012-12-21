#encoding: utf-8
class BlogController < ApplicationController
  def index
    @blogs=Blog.find_by_sql('select * from blog order by id desc')
  end
end
