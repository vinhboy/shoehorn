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
  end

end
