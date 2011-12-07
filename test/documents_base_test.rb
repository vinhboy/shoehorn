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
    
end