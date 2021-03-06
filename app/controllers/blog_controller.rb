#encoding: utf-8
class BlogController < ApplicationController
  def index
      if params[:id]==nil
         bid="0"
      else
         bid=(params[:id].to_i*7).to_s
      end
      if  params[:tag]==nil
        if params[:classify]==nil
          @blog=Blog.all
          @blogs=Blog.find_by_sql('select * from blog order by publishdate desc,id desc limit '+bid+',7')
        else
          @blog=Blog.find_by_sql('select * from blog where bcolumn="'+params[:classify]+'"')
          @blogs=Blog.find_by_sql('select * from blog where bcolumn="'+params[:classify]+'"'+'order by publishdate desc,id desc limit '+bid+',7')
        end
      else
        @tags='tag like "%'+ params[:tag] + '%"'
        if params[:tag1]!=nil
            @tags=@tags+' and tag like "%'+ params[:tag1] + '%"'
        end
        if params[:tag2]!=nil
            @tags=@tags+' and tag like "%'+ params[:tag2] + '%"'
        end
        if params[:tag3]!=nil
            @tags=@tags+' and tag like "%'+ params[:tag3] + '%"'
          end
        if params[:tag4]!=nil
            @tags=@tags+' and tag like "%'+ params[:tag4] + '%"'
        end
        if params[:classify]==nil
          @blog=Blog.find_by_sql('select * from blog where '+@tags)
          @blogs=Blog.find_by_sql('select * from blog  where '+@tags+' order by publishdate desc,id desc limit '+bid+',7')
        else
          @blog=Blog.find_by_sql('select * from blog where bcolumn="'+params[:classify]+'" and '+@tags)
          @blogs=Blog.find_by_sql('select * from blog where bcolumn="'+params[:classify]+'" and '+@tags+' order by publishdate desc,id desc limit '+bid+',7')
        end
      end
     @popular=Blog.find_by_sql('select * from blog order by count desc,id desc limit 0,5')
  end

  def all
      if params[:classify]=='理财技巧' || params[:classify]=='理财产品' || params[:tag]!=nil
        @classify=1
      else
        @classify=0
      end
      if params[:id]==nil
         bid="0"
      else
         bid=(params[:id].to_i*7).to_s
      end
      if  params[:tag]==nil
        if params[:classify]==nil
          @blog=Blog.all
          @blogs=Blog.find_by_sql('select * from blog order by publishdate desc,id desc limit '+bid+',7')
        else
          @blog=Blog.find_by_sql('select * from blog where bcolumn="'+params[:classify]+'"')
          @blogs=Blog.find_by_sql('select * from blog where bcolumn="'+params[:classify]+'"'+'order by publishdate desc,id desc limit '+bid+',7')
        end
      else
        @tags='tag like "%'+ params[:tag] + '%"'
        if params[:tag1]!=nil
          @tags=@tags+' and tag like "%'+ params[:tag1] + '%"'
        end
        if params[:tag2]!=nil
          @tags=@tags+' and tag like "%'+ params[:tag2] + '%"'
        end
        if params[:tag3]!=nil
          @tags=@tags+' and tag like "%'+ params[:tag3] + '%"'
          end
        if params[:tag4]!=nil
          @tags=@tags+' and tag like "%'+ params[:tag4] + '%"'
        end
        if params[:classify]==nil
          @blog=Blog.find_by_sql('select * from blog where '+@tags)
          @blogs=Blog.find_by_sql('select * from blog  where '+@tags+' order by publishdate desc,id desc limit '+bid+',7')
        else
          @blog=Blog.find_by_sql('select * from blog where bcolumn="'+params[:classify]+'" and '+@tags)
          @blogs=Blog.find_by_sql('select * from blog where bcolumn="'+params[:classify]+'" and '+@tags+' order by publishdate desc,id desc limit '+bid+',7')
        end
      end
      @popular=Blog.find_by_sql('select * from blog order by count desc,id desc limit 0,5')
  end

  def blogarticle
    @bloginfo=[]
    @comments=Comments.order("id desc").where(bid:params[:id])
    @popular=Blog.find_by_sql('select * from blog order by count desc,id desc limit 0,5')
    if params[:id]!="0"
      @blog=Blog.find_by_id(params[:id])
      @bloginfo[0]=@blog.btitle
      @bloginfo[1]=@blog.blname
      @bloginfo[2]=@blog.publishdate
      @bloginfo[3]=@blog.barticle
      @bloginfo[4]=@blog.bcolumn
      @bloginfo[5]=@blog.imagepath
      @bloginfo[6]=@blog.id
      @bloginfo[7]=@blog.tag
    end
    if @blog.tag != nil
      @tag=@blog.tag.split(",")
      @tags=""
      for i in 0..@tag.size-1
        if @tags==""
          @tags='tag like "%'+ @tag[i] + '%"'
        else
          @tags=@tags+' or tag like "%'+ @tag[i] + '%"'
        end
      end
      @tags='select * from blog where bcolumn="'+@blog.bcolumn+'" and ('+@tags+') and id<>'+@blog.id.to_s+' order by count desc,id desc limit 0,5'
      @interest=Blog.find_by_sql(@tags)
    else
      @interest=Blog.find_by_sql('select * from blog where bcolumn="'+@blog.bcolumn+'" and id<> '+@blog.id.to_s+' order by count desc,id desc limit 0,5')
    end
  end

  def article
    @bloginfo=[]
    @comments=Comments.order("id desc").where(bid:params[:id])
    @popular=Blog.find_by_sql('select * from blog order by count desc,id desc limit 0,5')
    if params[:id]!="0"
      @blog=Blog.find_by_id(params[:id])
      @bloginfo[0]=@blog.btitle
      @bloginfo[1]=@blog.blname
      @bloginfo[2]=@blog.publishdate
      @bloginfo[3]=@blog.barticle
      @bloginfo[4]=@blog.bcolumn
      @bloginfo[5]=@blog.imagepath
      @bloginfo[6]=@blog.id
      @bloginfo[7]=@blog.tag
    end
    if @blog.tag != nil
      @tag=@blog.tag.split(",")
      @tags=""
      for i in 0..@tag.size-1
        if @tags==""
          @tags='tag like "%'+ @tag[i] + '%"'
        else
          @tags=@tags+' or tag like "%'+ @tag[i] + '%"'
        end
      end
      @tags='select * from blog where bcolumn="'+@blog.bcolumn+'" and ('+@tags+') and id<>'+@blog.id.to_s+' order by count desc,id desc limit 0,5'
      @interest=Blog.find_by_sql(@tags)
    else
      @interest=Blog.find_by_sql('select * from blog where bcolumn="'+@blog.bcolumn+'" and id<> '+@blog.id.to_s+' order by count desc,id desc limit 0,5')
    end
  end

  def countconfigajax
      @blogs=Blog.find_by_id(params[:bid])
      @blogs.update_attributes(:count=>params[:count])
      render :json => "s1".to_json
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
