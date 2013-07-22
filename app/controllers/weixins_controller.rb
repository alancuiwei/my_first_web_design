# -*- encoding : utf-8 -*-
class WeixinsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :check_weixin_legality

  def show
    render :text => params[:echostr]
  end

  def create
  
	if params[:xml][:Event] == "subscribe"
		render "welcome", :formats => :xml
	end
	
    case params[:xml][:MsgType] 
	when "text"
	  case params[:xml][:Content]
	  when "100"
		render "rtn100", :formats => :xml
    when "101"
	  render "rtn101", :formats => :xml
	  when "200"
		render "rtn200", :formats => :xml		
    when "300"
	  render "rtn300", :formats => :xml		
    
	  else
	    render "echo", :formats => :xml
	  end      
  end
end

  private
  # 根据参数校验请求是否合法，如果非法返回错误页面
  def check_weixin_legality
    array = ["zhongren", params[:timestamp], params[:nonce]].sort
    render :text => "Forbidden", :status => 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
  end
end
