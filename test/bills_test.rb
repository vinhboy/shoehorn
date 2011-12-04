require File.dirname(__FILE__) + '/test_helper.rb'

class BillsTest < ShoehornTest

  context "initialization" do
    setup do
      @connection = Shoehorn::Connection.new
      @bills = @connection.bills
    end

    should "have a pointer back to the connection" do
      assert_equal @connection, @bills.connection
    end
  end

end
