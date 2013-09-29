class ErrorsController < ApplicationController
  def handle
    render :file => "#{Rails.root}/home/404.html.erb", :status => 404, :layout => false
  end
end