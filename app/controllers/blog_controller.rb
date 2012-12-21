#encoding: utf-8
class BlogController < ApplicationController
  def index
    @blogs=Blog.find_by_sql('select * from blog order by id desc')
  end

  def blogarticle
    @bloginfo=[]
    if params[:id]!="0"
      @blog=Blog.find_by_id(params[:id])
      @bloginfo[0]=@blog.btitle
      @bloginfo[1]=@blog.blname
      @bloginfo[2]=@blog.publishdate
      @bloginfo[3]=@blog.barticle
      @bloginfo[4]=@blog.bcolumn
      @bloginfo[5]=@blog.imagepath
    end
  end

  def blogbusinesslife
    @blogs=Blog.find_by_sql('select * from blog where bcolumn="创业人生" order by id desc')
  end

  def blogbankfinance
    @blogs=Blog.find_by_sql('select * from blog where bcolumn="银行理财产品" order by id desc')
  end
end
