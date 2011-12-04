require File.dirname(__FILE__) + '/test_helper.rb'

class ReceiptsTest < ShoehornTest

  context "initialization" do
    setup do
      @connection = live_connection
      @receipts = @connection.receipts
    end

    should "have a pointer back to the connection" do
      assert_equal @connection, @receipts.connection
    end
  end

end
