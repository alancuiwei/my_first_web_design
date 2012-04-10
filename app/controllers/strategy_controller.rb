#encoding: utf-8
require 'rubygems'

class StrategyController < ApplicationController
  $login=1
  def index

    respond_to do |format|
      format.html
#      format.json { render json: @strategywebs }
    end
  end

#  def show
#    respond_to do |format|
#      format.html
#    end
#  end

  def shownorisk
  end

  def intronorisk
  end

end
