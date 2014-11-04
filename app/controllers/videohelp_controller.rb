#encoding: utf-8
class VideohelpController < ApplicationController
    def index
      if session[:webusername]!=nil
        @webuser = Webuser.find_by_username(session[:webusername])
      end
    end
end