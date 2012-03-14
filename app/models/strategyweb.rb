class Strategyweb < ActiveRecord::Base
  has_many:webuserstrategies
  has_many:webusers,:through => :webuserstrategies
end
