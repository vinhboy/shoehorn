require File.dirname(__FILE__) + '/test_helper.rb'

class ReceiptsTest < Test::Unit::TestCase
  include Shoehorn

  context "initialization" do
    setup do
      @connection = Shoehorn::Connection.new
      @receipts = @connection.receipts
    end

    should "have a pointer back to the connection" do
      assert_equal @connection, @receipts.connection
    end
  end

end
