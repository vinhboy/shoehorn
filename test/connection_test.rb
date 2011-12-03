require File.dirname(__FILE__) + '/test_helper.rb'

class TestConnection < Test::Unit::TestCase
  include Shoehorn

  context "API" do
    should "know the right endpoint" do
      assert_equal "https://api.shoeboxed.com/v1/ws/api.htm", Shoehorn::Connection::API_ENDPOINT
    end
  end

  context "logger" do
    setup do
      @connection = Shoehorn::Connection.new
    end

    should "set up a new logger by default" do
      assert_not_nil @connection.logger
    end

    should "allow setting a logger" do
      new_logger = Logger.new(STDOUT)
      @connection.logger = new_logger
      assert_equal new_logger, @connection.logger
    end

    should "default to warning" do
      assert_equal Logger::WARN, @connection.log_level
    end

    should "allow setting the logging level" do
      @connection.log_level = Logger::INFO
      assert_equal Logger::INFO, @connection.log_level
    end
  end

end
