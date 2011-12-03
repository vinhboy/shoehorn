require File.dirname(__FILE__) + '/test_helper.rb'

class TestConnection < Test::Unit::TestCase
  include Shoehorn

  context "API" do
    should "know the right endpoint" do
      assert_equal "https://api.shoeboxed.com/v1/ws/api.htm", Shoehorn::Connection::API_ENDPOINT
    end
  end
end
