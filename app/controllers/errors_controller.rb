class ErrorsController < ApplicationController
  def handle
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
end