#encoding: utf-8
class BlogController < ApplicationController
  def index
    @blogs=Blog.all
  end
end
