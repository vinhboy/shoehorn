require File.dirname(__FILE__) + '/test_helper.rb'

class BusinessCardsTest < ShoehornTest

  context "initialization" do
    setup do
      @connection = live_connection
      @business_cards = @connection.business_cards
    end

    should "have a pointer back to the connection" do
      assert_equal @connection, @business_cards.connection
    end

    should "return an array of business cards" do
      assert @business_cards.is_a?(Array)
    end
  end

  context "parsing" do
    should "retrieve a list of business cards" do
      connection = Shoehorn::Connection.new
      FakeWeb.register_uri(:post, Shoehorn::Connection::API_ENDPOINT, :body => file_contents('get_business_card_call_response_1.xml'))
      business_cards = connection.business_cards
      assert_equal 4, business_cards.size
      assert_equal "331378049", business_cards[0].id
      assert_equal "Richard", business_cards[0].first_name
      assert_equal "Davies", business_cards[0].last_name
      assert_equal "2/5/2009", business_cards[0].create_date
      assert_equal "", business_cards[0].address
      assert_equal "", business_cards[0].address2
      assert_equal "RTP", business_cards[0].city
      assert_equal "NC", business_cards[0].state  
      assert_equal "27713", business_cards[0].zip
      assert_equal "USA", business_cards[0].country
      assert_equal "Richard@Samplecompany.com", business_cards[0].email
      assert_equal "", business_cards[0].website
      assert_equal "Plaza Bridge", business_cards[0].company
      assert_equal "Managing Partner", business_cards[0].position 
      assert_equal "919 555-0557", business_cards[0].work_phone
      assert_equal "", business_cards[0].cell_phone
      assert_equal "", business_cards[0].fax
      assert_equal "https://www.shoeboxed.com/business-card.jpeg?bcid=331378049&code=eb43ab329ef9902ps27bf2c1e4a93c51", business_cards[0].front_img_url
      assert_equal "https://www.shoeboxed.com/business-card.jpeg?bcid=331378049&back=y&code=eb43ab309ol99fc9727bf2c1e4a93c51", business_cards[0].back_img_url
      assert_equal "met at downtown Durham networking event", business_cards[0].note
    end

    should "retrieve the total number of available receipts" do
      connection = Shoehorn::Connection.new
      FakeWeb.register_uri(:post, Shoehorn::Connection::API_ENDPOINT, :body => file_contents('get_business_card_call_response_1.xml'))
      receipts = connection.business_cards   
      assert_equal 74, receipts.matched_count
    end  
  end

end
