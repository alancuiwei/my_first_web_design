require 'test_helper'

class WebuserTest < ActiveSupport::TestCase
  test "webuser attributes checking test" do
    webuser_test = Webuser.new
    assert webuser_test.invalid?
    assert webuser_test.errors[:name].any?
  end

end
