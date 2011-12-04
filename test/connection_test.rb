require File.dirname(__FILE__) + '/test_helper.rb'

class ConnectionTest <ShoehornTest

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

      should "allow setting after initializing" do
        connection = Shoehorn::Connection.new
        connection.application_name = 'GreatApp'
        assert_equal 'GreatApp', connection.application_name
      end
    end

    context "application token" do
      should "allow passing when initializing" do
        connection = Shoehorn::Connection.new('GreatApp', 'ABCDEF')
        assert_equal 'ABCDEF', connection.application_token
      end

      should "allow setting after initializing" do
        connection = Shoehorn::Connection.new
        connection.application_token = 'ABCDEF'
        assert_equal 'ABCDEF', connection.application_token
      end
    end

    context "return URL" do
      should "allow passing when initializing" do
        connection = Shoehorn::Connection.new('GreatApp', 'ABCDEF', 'http://greatapp.example.com')
        assert_equal 'http://greatapp.example.com', connection.return_url
      end

      should "allow setting after initializing" do
        connection = Shoehorn::Connection.new
        connection.return_url = 'http://greatapp.example.com'
        assert_equal 'http://greatapp.example.com', connection.return_url
      end
    end

    context "return URL params" do
      should "allow passing when initializing" do
        connection = Shoehorn::Connection.new('GreatApp', 'ABCDEF', 'http://greatapp.example.com', {:param => 'value'})
        assert_equal 'param=value', connection.return_parameters
      end

      should "allow setting after initializing" do
        connection = Shoehorn::Connection.new
        connection.return_parameters = 'param=value'
        assert_equal 'param=value', connection.return_parameters
      end
    end
  end

  context "authentication URL" do
    context "required parameters" do
      should "require application name" do
        assert_raise Shoehorn::ParameterError do
          connection = Shoehorn::Connection.new
          authentication_url = connection.authentication_url
        end
      end

      should "require return URL" do
        assert_raises Shoehorn::ParameterError do
          connection = Shoehorn::Connection.new("GreatApp")
          authentication_url = connection.authentication_url
        end
      end

      should "not require return params" do
        assert_nothing_raised do
          connection = Shoehorn::Connection.new('GreatApp', 'ABCDEF', 'http://greatapp.example.com')
          authentication_url = connection.authentication_url
        end
      end
    end

    should "Generate a properly encoded authentication URL" do
      connection = Shoehorn::Connection.new('GreatApp', 'ABCDEF', 'http://greatapp.example.com')
      assert_equal "https://api.shoeboxed.com/v1/ws/api.htm?appname=GreatApp&appurl=http%3A%2F%2Fgreatapp.example.com&apparams=&SignIn=1", connection.authentication_url
    end
  end

  context "collections" do
    setup do
      @connection = live_connection
    end

    should "initialize bills when first accessed" do
      Shoehorn::Bills.any_instance.expects(:get_bills).once
      bills = @connection.bills
    end   
    
    should "not initialize bills on second access" do
      Shoehorn::Bills.any_instance.expects(:get_bills).once
      bills = @connection.bills
      bills = @connection.bills
    end
    
    should "initialize bills on refresh" do
      bills = @connection.bills
      Shoehorn::Bills.any_instance.expects(:get_bills).once
      bills.refresh
    end

    should "initialize business cards when first accessed" do
      Shoehorn::BusinessCards.any_instance.expects(:get_business_cards).once
      business_cards = @connection.business_cards
    end   
    
    should "not initialize business cards on second access" do
      Shoehorn::BusinessCards.any_instance.expects(:get_business_cards).once
      business_cards = @connection.business_cards
      business_cards = @connection.business_cards
    end
    
    should "initialize business cards on refresh" do
      business_cards = @connection.business_cards
      Shoehorn::BusinessCards.any_instance.expects(:get_business_cards).once
      business_cards.refresh
    end

    should "initialize categories when first accessed" do
      Shoehorn::Categories.any_instance.expects(:get_categories).once
      categories = @connection.categories
    end   
    
    should "not initialize categories on second access" do
      Shoehorn::Categories.any_instance.expects(:get_categories).once
      categories = @connection.categories
      categories = @connection.categories
    end
    
    should "initialize categories on refresh" do
      categories = @connection.categories
      Shoehorn::Categories.any_instance.expects(:get_categories).once
      categories.refresh
    end

    should "initialize other documents when first accessed" do
      Shoehorn::OtherDocuments.any_instance.expects(:get_other_documents).once
      other_documents = @connection.other_documents
    end   
    
    should "not initialize other documents on second access" do
      Shoehorn::OtherDocuments.any_instance.expects(:get_other_documents).once
      other_documents = @connection.other_documents
      other_documents = @connection.other_documents
    end
    
    should "initialize other documents on refresh" do
      other_documents = @connection.other_documents
      Shoehorn::OtherDocuments.any_instance.expects(:get_other_documents).once
      other_documents.refresh
    end

    should "initialize receipts when first accessed" do
      Shoehorn::Receipts.any_instance.expects(:get_receipts).once
      receipts = @connection.receipts
    end   
    
    should "not initialize receipts on second access" do
      Shoehorn::Receipts.any_instance.expects(:get_receipts).once
      receipts = @connection.receipts
      receipts = @connection.receipts
    end
    
    should "initialize receipts on refresh" do
      receipts = @connection.receipts
      Shoehorn::Receipts.any_instance.expects(:get_receipts).once
      receipts.refresh
    end

  end

end
