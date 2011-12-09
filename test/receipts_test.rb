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
      connection = mock_response('get_receipt_call_response_1.xml')
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
      connection = mock_response('get_receipt_call_response_1.xml')
      receipts = connection.receipts
      assert_equal 2, receipts.matched_count
      assert_equal 1, receipts.total_pages
    end

    should "retrieve an array of categories for each receipt" do
      connection = mock_response('get_receipt_call_response_1.xml')
      receipts = connection.receipts
      assert_equal 3, receipts[0].categories.size
      assert_equal "23423342", receipts[0].categories[0].id
      assert_equal "Meals / Entertainment", receipts[0].categories[0].name
    end

    should "retrieve an array of images for each receipt" do
      connection = mock_response('get_receipt_call_response_1.xml')
      receipts = connection.receipts
      assert_equal 3, receipts[0].images.size
      assert_equal "1", receipts[0].images[0].index
      assert_equal "http://www.shoeboxed.com/api/document/jpg/receipt/724959232/dfb2fb21498668f95f1c927991818842/1", receipts[0].images[0].imgurl
    end
  end

  context "find_by_id" do
    should "return a single receipt" do
      connection = mock_response('get_receipt_info_call_response.xml')
      receipt = connection.receipts.find_by_id("139595947")
      assert_equal "139595947", receipt.id
      assert_equal "Morgan Imports", receipt.store
      assert_equal "$1,929.00", receipt.total
      assert_equal "USD", receipt.document_currency
      assert_equal "USD", receipt.account_currency
      assert_equal "1", receipt.conversion_rate
      assert_equal "1929.00", receipt.document_total
      assert_equal "1929.00", receipt.converted_total
      assert_equal "$1,929.00", receipt.formatted_document_total
      assert_equal "$1,929.00", receipt.formatted_converted_total
      assert_equal "", receipt.document_tax
      assert_equal "", receipt.converted_tax
      assert_equal "", receipt.formatted_document_tax
      assert_equal "", receipt.formatted_converted_tax
      assert_equal "7/12/2008", receipt.modified_date
      assert_equal "7/10/2008", receipt.created_date
      assert_equal "5/12/2008", receipt.selldate

      assert_equal 3, receipt.categories.size
      assert_equal "23423342", receipt.categories[0].id
      assert_equal "Meals / Entertainment", receipt.categories[0].name
    end

    # TODO: Check what Shoeboxed returns if ID doesn't match
    should_eventually "return nil if no such receipt"

  end

  context "options" do
    setup do
      connection = mock_response('get_receipt_call_response_1.xml')
      @receipts = connection.receipts
    end

    should "allow setting modified_since" do
      @receipts.modified_since = Date.new(2011, 12, 10)
      assert_equal Date.new(2011, 12, 10), @receipts.modified_since
    end

    should "allow setting category_id" do
      @receipts.category_id = 5
      assert_equal 5, @receipts.category_id
    end

    should "know when the results are filtered by date" do
      assert !@receipts.filtered?
      @receipts.modified_since = Date.new(2011, 12, 10)
      assert @receipts.filtered?
    end

    should "know when the results are filtered by category" do
      assert !@receipts.filtered?
      @receipts.category_id = 5
      assert @receipts.filtered?
    end

    should "reinitialize if changing category" do
      Receipts.any_instance.expects(:get_page).once
      @receipts.modified_since = Date.new(2011, 12, 10)
    end

    should "not reinitialize if category remains unchanged" do
      Receipts.any_instance.expects(:get_page).once
      @receipts.modified_since = Date.new(2011, 12, 10)
      @receipts.modified_since = Date.new(2011, 12, 10)
    end

    should "reinitialize if changing modified_since" do
      Receipts.any_instance.expects(:get_page).once
      @receipts.modified_since = Date.new(2011, 12, 10)
    end

    should "not reinitialize if modified_since remains unchanged" do
      Receipts.any_instance.expects(:get_page).once
      @receipts.modified_since = Date.new(2011, 12, 10)
      @receipts.modified_since = Date.new(2011, 12, 10)
    end
  end

  context "pagination" do
    setup do
      connection = mock_response('get_receipt_call_response_1.xml')
      @receipts = connection.receipts
    end

    should "record initial page retrieval" do
      assert_equal [1], @receipts.pages_retrieved
    end
  end

end

