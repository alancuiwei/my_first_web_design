#encoding: utf-8
class ArbcostmaxreturnrateV < ApplicationController
  # GET /usercommodity_ts
  # GET /usercommodity_ts.json
  def index
    @arbcostmaxreturnrate_vs = ArbcostmaxreturnrateV.all

    respond_to do |format|
      format.html # index.html.erb
      # format.json { render json: @usercommodity_ts }
    end
  end
end