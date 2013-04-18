#encoding: utf-8
class BlogController < ApplicationController
  def index
    @blogs=Blog.find_by_sql('select * from blog order by publishdate desc')
    #    @blogs=Blog.order("publishdate desc").page(params[:page])
  end

  def blogarticle
    @bloginfo=[]
    @comments=Comments.order("id desc").find_all_by_bid(params[:id])
    if params[:id]!="0"
      @blog=Blog.find_by_id(params[:id])
      @bloginfo[0]=@blog.btitle
      @bloginfo[1]=@blog.blname
      @bloginfo[2]=@blog.publishdate
      @bloginfo[3]=@blog.barticle
      @bloginfo[4]=@blog.bcolumn
      @bloginfo[5]=@blog.imagepath
      @bloginfo[6]=@blog.id
    end
  end

  def commentconfigajax
    Comments.new do |b|
      b.username=params[:username]
      b.email=params[:email]
      b.comments=params[:comments]
      b.bid=params[:blogid]
      b.time=params[:time]
      b.save
    end
    render :json => "s1".to_json
  end

  def blogbusinesslife
    @blogs=Blog.find_by_sql('select * from blog where bcolumn="创业人生" order by publishdate desc')
  end

  def blogbankfinance
    @blogs=Blog.find_by_sql('select * from blog where bcolumn="银行理财产品" order by publishdate desc')
  end
end
