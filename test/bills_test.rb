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
      connection = mock_response('get_bill_call_response_1.xml')
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

    should "retrieve the total number of available bills" do
      connection = mock_response('get_bill_call_response_1.xml')
      bills = connection.bills
      assert_equal 2, bills.matched_count
    end

    should "retrieve an array of images for each bill" do
      connection = mock_response('get_bill_call_response_1.xml')
      bills = connection.bills
      assert_equal 2, bills[0].images.size
      assert_equal "1", bills[0].images[0].index
      assert_equal "https://app.shoeboxed.com/api/document/jpg/bill/123884/194ae40d7dfd8b2a4b3089991d1939e3/1", bills[0].images[0].imgurl
    end

  end
  
  context "find_by_id" do
    should "return a single bill" do
      connection = mock_response('get_bill_info_call_response.xml')
      bill = connection.bills.find_by_id("123884")
      assert_equal "123884", bill.id
      assert_equal "", bill.envelope_code
      assert_equal "02/04/2011", bill.create_date
      assert_equal "02/04/2011", bill.modify_date
      assert_equal "Power Bill", bill.name
      assert_equal "USD", bill.document_currency
      assert_equal "USD", bill.account_currency
      assert_equal "1", bill.conversion_rate
      assert_equal "125.89", bill.document_total
      assert_equal "125.89", bill.converted_total
      assert_equal "$125.89", bill.formatted_document_total
      assert_equal "$125.89", bill.formatted_converted_total
      
      assert_equal 2, bill.images.size
      assert_equal "1", bill.images[0].index
      assert_equal "https://app.shoeboxed.com/api/document/jpg/bill/123884/194ae40d7dfd8b2a4b3089991d1939e3/1", bill.images[0].imgurl
    end
    
    # TODO: Check what Shoeboxed returns if ID doesn't match
    should_eventually "return nil if no such bill"
    
  end
  
end
