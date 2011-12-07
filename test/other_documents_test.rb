require File.dirname(__FILE__) + '/test_helper.rb'

class OtherDocumentsTest < ShoehornTest

  context "initialization" do
    setup do
      @connection = live_connection
      @other_documents = @connection.other_documents
    end

    should "have a pointer back to the connection" do
      assert_equal @connection, @other_documents.connection
    end

    should "return an array of other documents" do
      assert @other_documents.is_a?(Array)
    end
  end

  context "parsing" do
    should "retrieve a list of other documents" do
      connection = mock_response('get_other_document_call_response_1.xml')
      other_documents = connection.other_documents
      assert_equal 2, other_documents.size
      assert_equal "124532", other_documents[0].id
      assert_equal "BYWFW2Y0", other_documents[0].envelope_code
      assert_equal "06/13/2011", other_documents[0].create_date
      assert_equal "06/13/2011", other_documents[0].modify_date
      assert_equal "Bank Statement 05/2011", other_documents[0].name
    end

    should "retrieve the total number of available other documents" do
      connection = mock_response('get_other_document_call_response_1.xml')
      other_documents = connection.other_documents
      assert_equal 2, other_documents.matched_count   
      assert_equal 1, other_documents.total_pages
    end

    should "retrieve an array of images for each other document" do
      connection = mock_response('get_other_document_call_response_1.xml')
      other_documents = connection.other_documents
      assert_equal 4, other_documents[0].images.size
      assert_equal "1", other_documents[0].images[0].index
      assert_equal "https://app.shoeboxed.com/api/document/jpg/other-document/124532/fbf1aa28d58bec87206db315f70978ff/1", other_documents[0].images[0].imgurl
    end

  end

  context "find_by_id" do
    should "return a single other_document" do
      connection = mock_response('get_other_document_info_call_response.xml')
      other_document = connection.other_documents.find_by_id("123884")
      assert_equal "124532", other_document.id
      assert_equal "BYWFW2Y0", other_document.envelope_code
      assert_equal "06/13/2011", other_document.create_date
      assert_equal "06/13/2011", other_document.modify_date
      assert_equal "Bank Statement 05/2011", other_document.name

      assert_equal 4, other_document.images.size
      assert_equal "1", other_document.images[0].index
      assert_equal "https://app.shoeboxed.com/api/document/jpg/other-document/124532/fbf1aa28d58bec87206db315f70978ff/1", other_document.images[0].imgurl
    end

    # TODO: Check what Shoeboxed returns if ID doesn't match
    should_eventually "return nil if no such other document"

  end
  
  context "options" do   
    setup do
      connection = mock_response('get_other_document_call_response_1.xml')
      @other_documents = connection.other_documents
    end
    
    should "allow setting modified_since" do
      @other_documents.modified_since = Date.new(2011, 12, 10)
      assert_equal Date.new(2011, 12, 10), @other_documents.modified_since  
    end
    
    should "know when the results are filtered" do
      assert !@other_documents.filtered?
      @other_documents.modified_since = Date.new(2011, 12, 10)
      assert @other_documents.filtered?
    end

    should "reinitialize if changing modified_since" do
      OtherDocuments.any_instance.expects(:get_other_documents).once
      @other_documents.modified_since = Date.new(2011, 12, 10)
    end

    should "not reinitialize if modified_since remains unchanged" do
      OtherDocuments.any_instance.expects(:get_other_documents).once
      @other_documents.modified_since = Date.new(2011, 12, 10)
      @other_documents.modified_since = Date.new(2011, 12, 10)
    end
  end
  
end
