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
   
    should "set up a new logger when using initialize with parameters" do
      connection = Shoehorn::Connection.new('GreatApp')
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

  context "authentication params" do
    context "application name" do
      should "allow passing when initializing" do
        connection = Shoehorn::Connection.new('GreatApp')
        assert_equal 'GreatApp', connection.application_name
      end

      should "allow setting after initializig" do
        connection = Shoehorn::Connection.new
        connection.application_name = 'GreatApp'
        assert_equal 'GreatApp', connection.application_name
      end
    end

    context "return URL" do
      should "allow passing when initializing" do
        connection = Shoehorn::Connection.new('GreatApp', 'http://greatapp.example.com')
        assert_equal 'http://greatapp.example.com', connection.return_url
      end

      should "allow setting after initializig" do
        connection = Shoehorn::Connection.new
        connection.return_url = 'http://greatapp.example.com'
        assert_equal 'http://greatapp.example.com', connection.return_url
      end
    end

    context "return URL params" do
      should "allow passing when initializing" do
        connection = Shoehorn::Connection.new('GreatApp', 'http://greatapp.example.com', {:param => 'value'})
        assert_equal 'param=value', connection.return_parameters
      end

      should "allow setting after initializig" do
        connection = Shoehorn::Connection.new
        connection.return_parameters = 'param=value'
        assert_equal 'param=value', connection.return_parameters
      end
    end
  end

end
