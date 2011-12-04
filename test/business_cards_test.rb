require File.dirname(__FILE__) + '/test_helper.rb'

class BusinessCardsTest < Test::Unit::TestCase
  include Shoehorn

  context "initialization" do
    setup do
      @connection = Shoehorn::Connection.new
      @business_cards = @connection.business_cards
    end

    should "have a pointer back to the connection" do
      assert_equal @connection, @business_cards.connection
    end
  end

end
