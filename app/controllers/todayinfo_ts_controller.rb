#encoding: utf-8
class TodayinfoT < ApplicationController
  # GET /usercommodity_ts
  # GET /usercommodity_ts.json
  def index
    @todayinf_ts = TodayinfoT.all

    respond_to do |format|
      format.html # index.html.erb
      # format.json { render json: @usercommodity_ts }
    end
  end
end