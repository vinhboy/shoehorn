require File.dirname(__FILE__) + '/test_helper.rb'

class DocumentsBaseTest < ShoehornTest
   
    context "status" do
      setup do  
        @connection = mock_response('get_document_status_call_response.xml')
      end                                                              
      
      should "allow retrieving status on Bills" do     
        expected_hash = {:status => "DONE", :document_id => "8374927320", :document_type => "Receipt"}
        assert_equal expected_hash, @connection.bills.status("f96fae3fdc7774746f5ee53e2277975cd516aeae")
      end

      should "allow retrieving status on Business Cards" do
        expected_hash = {:status => "DONE", :document_id => "8374927320", :document_type => "Receipt"}
        assert_equal expected_hash, @connection.business_cards.status("f96fae3fdc7774746f5ee53e2277975cd516aeae")
      end

      should "allow retrieving status on Other Documents" do
        expected_hash = {:status => "DONE", :document_id => "8374927320", :document_type => "Receipt"}
        assert_equal expected_hash, @connection.other_documents.status("f96fae3fdc7774746f5ee53e2277975cd516aeae")
      end

      should "allow retrieving status on Receipts" do
        expected_hash = {:status => "DONE", :document_id => "8374927320", :document_type => "Receipt"}
        assert_equal expected_hash, @connection.receipts.status("f96fae3fdc7774746f5ee53e2277975cd516aeae")
      end
    end

    context "#modified_since" do
      setup do  
        @connection = mock_response('get_document_status_call_response.xml')
      end                                                              
      
      should "normalize String to formatted string" do
        @connection.receipts.modified_since = '2011-12-01'
        assert_equal "12/01/2011", @connection.receipts.modified_since
      end                                                                      
      
      should "normalize DateTime to String" do
        @connection.receipts.modified_since = DateTime.new(2011, 12, 01)
        assert_equal "12/01/2011", @connection.receipts.modified_since
      end                                                              
      
      should "normalize Date to String" do
        @connection.receipts.modified_since = Date.new(2011, 12, 01)
        assert_equal "12/01/2011", @connection.receipts.modified_since
      end
      
      should "raise if fed junk" do
        assert_raises Shoehorn::ParameterError do
          @connection.receipts.modified_since = {:foo => "bar"}
        end                                                  
      end
         
      should "allow setting to nil" do
        assert_nothing_raised do
          @connection.receipts.modified_since = nil
        end
      end
    end
    
end