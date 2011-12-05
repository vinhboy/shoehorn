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

    should "return an array of receipts" do
      assert @receipts.is_a?(Array)
    end
  end

  context "parsing" do
    should "retrieve a list of receipts" do
      connection = Shoehorn::Connection.new
      FakeWeb.register_uri(:post, Shoehorn::Connection::API_ENDPOINT, :body => file_contents('get_receipt_call_response_1.xml'))
      receipts = connection.receipts
      assert_equal 2, receipts.size
      assert_equal "23984923842", receipts[0].id
      assert_equal "Great Plains Trust Company", receipts[0].store
      assert_equal "$3,378.30", receipts[0].total
      assert_equal "USD", receipts[0].document_currency
      assert_equal "USD", receipts[0].account_currency
      assert_equal "1", receipts[0].conversion_rate
      assert_equal "3378.30", receipts[0].document_total
      assert_equal "3378.30", receipts[0].converted_total  
      assert_equal "$3,378.30", receipts[0].formatted_document_total
      assert_equal "$3,378.30", receipts[0].formatted_converted_total
      assert_equal "", receipts[0].document_tax
      assert_equal "", receipts[0].converted_tax
      assert_equal "", receipts[0].formatted_document_tax
      assert_equal "", receipts[0].formatted_converted_tax 
      assert_equal "7/12/2008", receipts[0].modified_date
      assert_equal "7/10/2008", receipts[0].created_date
      assert_equal "5/12/2008", receipts[0].selldate
    end

    should "retrieve the total number of available receipts" do
      connection = Shoehorn::Connection.new
      FakeWeb.register_uri(:post, Shoehorn::Connection::API_ENDPOINT, :body => file_contents('get_receipt_call_response_1.xml'))
      receipts = connection.receipts   
      assert_equal 2, receipts.matched_count
    end  

    should "retrieve an array of categories for each receipt" do
      connection = Shoehorn::Connection.new
      FakeWeb.register_uri(:post, Shoehorn::Connection::API_ENDPOINT, :body => file_contents('get_receipt_call_response_1.xml'))
      receipts = connection.receipts   
      assert_equal 3, receipts[0].categories.size
      assert_equal "23423342", receipts[0].categories[0].id
      assert_equal "Meals / Entertainment", receipts[0].categories[0].name
    end

    should "retrieve an array of images for each receipt" do
      connection = Shoehorn::Connection.new
      FakeWeb.register_uri(:post, Shoehorn::Connection::API_ENDPOINT, :body => file_contents('get_receipt_call_response_1.xml'))
      receipts = connection.receipts   
      assert_equal 3, receipts[0].images.size
      assert_equal "1", receipts[0].images[0].index
      assert_equal "http://www.shoeboxed.com/api/document/jpg/receipt/724959232/dfb2fb21498668f95f1c927991818842/1", receipts[0].images[0].imgurl
    end
  end
  
end
