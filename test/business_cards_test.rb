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
      connection = mock_response('get_business_card_call_response_1.xml')
      business_cards = connection.business_cards
      assert_equal 74, business_cards.size
      assert_equal "331378049", business_cards[0].id
      assert_equal "Richard", business_cards[0].first_name
      assert_equal "Davies", business_cards[0].last_name
      assert_equal Date.new(2009, 2, 5), business_cards[0].create_date
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

    should "retrieve the total number of available business cards" do
      connection = mock_response('get_business_card_call_response_1.xml')
      business_cards = connection.business_cards
      assert_equal 74, business_cards.matched_count
      assert_equal 2, business_cards.total_pages
    end
  end

  context "find_by_id" do
    should "return a single business card" do
      connection = mock_response('get_business_card_info_call_response.xml')
      business_card = connection.business_cards.find_by_id("331378049")
      assert_equal "331378049", business_card.id
      assert_equal "Richard", business_card.first_name
      assert_equal "Davies", business_card.last_name
      assert_equal Date.new(2009, 2, 5), business_card.create_date
      assert_equal "", business_card.address
      assert_equal "", business_card.address2
      assert_equal "RTP", business_card.city
      assert_equal "NC", business_card.state
      assert_equal "27713", business_card.zip
      assert_equal "USA", business_card.country
      assert_equal "Richard@Samplecompany.com", business_card.email
      assert_equal "", business_card.website
      assert_equal "Plaza Bridge", business_card.company
      assert_equal "Managing Partner", business_card.position
      assert_equal "919 555-0557", business_card.work_phone
      assert_equal "", business_card.cell_phone
      assert_equal "", business_card.fax
      assert_equal "https://www.shoeboxed.com/business-card.jpeg?bcid=331378049&code=eb43ab329ef9902ps27bf2c1e4a93c51", business_card.front_img_url
      assert_equal "https://www.shoeboxed.com/business-card.jpeg?bcid=331378049&back=y&code=eb43ab309ol99fc9727bf2c1e4a93c51", business_card.back_img_url
      assert_equal "met at downtown Durham networking event", business_card.note
    end

    # TODO: Check what Shoeboxed returns if ID doesn't match
    should_eventually "return nil if no such business card"

  end

  context "PDFs" do
    should "Get the estimated size of the PDF" do
      connection = mock_response('estimate_pdf_business_card_report_call_response.xml')
      cards, pages = connection.business_cards.estimate_pdf_business_card_report
      assert_equal 140, cards
      assert_equal 70, pages
    end

    should "Get a URL for the PDF" do
      connection = mock_response('generate_pdf_business_card_report_call_response.xml')
      assert_equal "https://app.shoeboxed.com/api/export/pdf-business-cards/198375212/65708a18ea05969e72f69dc289077fff", connection.business_cards.generate_pdf_business_card_report
    end
  end

  context "options" do
    should "Get the user's export options" do
      connection = mock_response('get_business_cards_exports_call_response.xml')
      h = {"DEFAULT" => true, "EVERNOTE" => true, "GOOGLE_MAIL" => true, "YAHOO_MAIL" => false}
      assert_equal h, connection.business_cards.get_business_card_exports
    end

    should "Know when business card auto-share mode is on" do
      connection = mock_response('get_business_card_notify_preference_call_response_on.xml')
      assert connection.business_cards.notify_preference
    end

    should "Know when business card auto-share mode is off" do
      connection = mock_response('get_business_card_notify_preference_call_response_off.xml')
      assert !connection.business_cards.notify_preference
    end

    # TODO: Worth testing this live?
    should_eventually "Allow setting auto-share mode"

    should "Get the viral text" do
      connection = mock_response('get_viral_business_card_email_text_call_response_off.xml')
      assert_equal "The email text...", connection.business_cards.get_viral_business_card_email_text
    end

    should "Get the user's auto-share contact details" do
      connection = mock_response('get_auto_share_contact_details_call_response.xml')
      h = {:first_name => "John", :last_name => "Doe", :email => "john.doe@gmail.com", :additional_contact_info => "Only email on weekends"}
      assert_equal h, connection.business_cards.auto_share_contact_details
    end

    # TODO: Worth testing this live?
    should_eventually "Allow updating auto-share contact details"
  end

  context "options" do
    setup do
      connection = mock_response('get_business_card_call_response_1.xml')
      @business_cards = connection.business_cards
    end

    should "allow setting modified_since" do
      @business_cards.modified_since = Date.new(2011, 12, 10)
      assert_equal DateTime.new(2011, 12, 10), @business_cards.modified_since
    end

    should "know when the results are filtered" do
      assert !@business_cards.filtered?
      @business_cards.modified_since = Date.new(2011, 12, 10)
      assert @business_cards.filtered?
    end

    should "reinitialize if changing modified_since" do
      BusinessCards.any_instance.expects(:get_page).once
      @business_cards.modified_since = Date.new(2011, 12, 10)
    end

    should "not reinitialize if modified_since remains unchanged" do
      BusinessCards.any_instance.expects(:get_page).once
      @business_cards.modified_since = Date.new(2011, 12, 10)
      @business_cards.modified_since = Date.new(2011, 12, 10)
    end
  end

  context "pagination" do
    setup do
      connection = mock_response('get_business_card_call_response_1.xml')
      @business_cards = connection.business_cards
    end

    should "record initial page retrieval" do
      assert_equal [1], @business_cards.pages_retrieved
    end
  end

end
