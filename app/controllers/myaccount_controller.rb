require 'date'
class MyaccountController < ApplicationController
  def investrecord
    @funds=Investrecord.find_all_by_username_and_recordtype("feifan","fund")
    @interests=Investrecord.find_all_by_username_and_recordtype("feifan","interest")
    @allfund=0
    @funds.each do |f|
      @allfund=@allfund+f.recordvalue
    end
    @allinterest=0
    @interests.each do |i|
      @allinterest=@allinterest+i.recordvalue
    end
    @allinvest=@allfund+@allinterest

  end
end
