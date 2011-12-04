require File.dirname(__FILE__) + '/test_helper.rb'

class CategoriesTest < ShoehornTest

  context "initialization" do
    setup do
      @connection = live_connection
      @categories = @connection.categories
    end

    should "have a pointer back to the connection" do
      assert_equal @connection, @categories.connection
    end

    should "return an array of categories" do
      assert @categories.is_a?(Array)
    end
  end

  context "parsing" do
    should "retrieve a list of categories" do
      connection = Shoehorn::Connection.new
      FakeWeb.register_uri(:post, Shoehorn::Connection::API_ENDPOINT, :body => file_contents('get_category_call_response.xml'))
      categories = connection.categories
      assert_equal 4, categories.size
      assert_equal "239763456", categories[0].id
      assert_equal "Auto / Fuel", categories[0].name
    end
  end

end
