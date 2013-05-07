#encoding: utf-8
class BlogController < ApplicationController
  def index
      if params[:id]==nil
         bid="0"
      else
         bid=(params[:id].to_i*7).to_s
      end
      if params[:classify]==nil
       @blog=Blog.all
       @blogs=Blog.find_by_sql('select * from blog order by publishdate desc limit '+bid+',7')
      else
        @blog=Blog.find_by_sql('select * from blog where bcolumn="'+params[:classify]+'"')
        @blogs=Blog.find_by_sql('select * from blog where bcolumn="'+params[:classify]+'"'+'order by publishdate desc limit '+bid+',7')
      end
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

  def article
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
end
