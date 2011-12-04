require File.dirname(__FILE__) + '/test_helper.rb'

class OtherDocumentsTest < ShoehornTest

  context "initialization" do
    setup do
      @connection = Shoehorn::Connection.new
      @other_documents = @connection.other_documents
    end

    should "have a pointer back to the connection" do
      assert_equal @connection, @other_documents.connection
    end
  end

end
