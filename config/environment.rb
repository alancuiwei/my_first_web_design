# Load the rails application
require File.expand_path('../application', __FILE__)
ActiveRecord::Base.pluralize_table_names = false
require 'will_paginate'
# Initialize the rails application
Ver01::Application.initialize!