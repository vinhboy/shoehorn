require File.dirname(__FILE__) + '/test_helper.rb'

class BillsTest < ShoehornTest

  context "initialization" do
    setup do
      @connection = live_connection
      @bills = @connection.bills
    end

    should "have a pointer back to the connection" do
      assert_equal @connection, @bills.connection
    end

    should "return an array of bills" do
      assert @bills.is_a?(Array)
    end
  end

  context "parsing" do
    should "retrieve a list of Bills" do
      connection = Shoehorn::Connection.new
      FakeWeb.register_uri(:post, Shoehorn::Connection::API_ENDPOINT, :body => file_contents('get_bill_call_response_1.xml'))
      bills = connection.bills
      assert_equal 2, bills.size
      assert_equal "123884", bills[0].id
      assert_equal "", bills[0].envelope_code
      assert_equal "02/04/2011", bills[0].create_date
      assert_equal "02/04/2011", bills[0].modify_date
      assert_equal "Power Bill", bills[0].name
      assert_equal "USD", bills[0].document_currency
      assert_equal "USD", bills[0].account_currency
      assert_equal "1", bills[0].conversion_rate
      assert_equal "125.89", bills[0].document_total
      assert_equal "125.89", bills[0].converted_total
      assert_equal "$125.89", bills[0].formatted_document_total
      assert_equal "$125.89", bills[0].formatted_converted_total
    end
  end

  should "retrieve the total number of available bills" do
    connection = Shoehorn::Connection.new
    FakeWeb.register_uri(:post, Shoehorn::Connection::API_ENDPOINT, :body => file_contents('get_bill_call_response_1.xml'))
    bills = connection.bills
    assert_equal 2, bills.matched_count
  end

  should "retrieve an array of images for each bill" do
    connection = Shoehorn::Connection.new
    FakeWeb.register_uri(:post, Shoehorn::Connection::API_ENDPOINT, :body => file_contents('get_bill_call_response_1.xml'))
    bills = connection.bills
    assert_equal 2, bills[0].images.size
    assert_equal "1", bills[0].images[0].index
    assert_equal "https://app.shoeboxed.com/api/document/jpg/bill/123884/194ae40d7dfd8b2a4b3089991d1939e3/1", bills[0].images[0].imgurl
  end

end
