module Shoehorn
  class BusinessCards  < DocumentsBase

    def initialize(connection)
      @connection = connection
      initialize_options
      business_cards, @matched_count = get_business_cards
      super(business_cards || [])
    end

    def self.parse(xml)
      business_cards = Array.new
      document = REXML::Document.new(xml)
      matched_count = document.elements["GetBusinessCardCallResponse"].elements["BusinessCards"].attributes["count"].to_i rescue 1
      document.elements.collect("//BusinessCard") do |business_card_element|
        begin
          business_card = BusinessCard.new
          business_card.id = business_card_element.attributes["id"]
          business_card.first_name = business_card_element.attributes["firstName"]
          business_card.last_name = business_card_element.attributes["lastName"]
          business_card.create_date = business_card_element.attributes["createDate"]
          business_card.address = business_card_element.attributes["address"]
          business_card.address2 = business_card_element.attributes["address2"]
          business_card.city = business_card_element.attributes["city"]
          business_card.state = business_card_element.attributes["state"]
          business_card.zip = business_card_element.attributes["zip"]
          business_card.country = business_card_element.attributes["country"]
          business_card.email = business_card_element.attributes["email"]
          business_card.website = business_card_element.attributes["website"]
          business_card.company = business_card_element.attributes["company"]
          business_card.position = business_card_element.attributes["position"]
          business_card.work_phone = business_card_element.attributes["workPhone"]
          business_card.cell_phone = business_card_element.attributes["cellPhone"]
          business_card.fax = business_card_element.attributes["fax"]
          business_card.front_img_url = business_card_element.attributes["frontImgUrl"]
          business_card.back_img_url = business_card_element.attributes["backImgUrl"]
          business_card.note = business_card_element.attributes["note"]
        rescue => e
          raise Shoehorn::ParseError.new(e, receipt_element.to_s, "Error parsing receipt.")
        end
        business_cards << business_card
      end
      return business_cards, matched_count
    end

    def find_by_id(id)
      request = build_single_business_card_request(id)
      response = connection.post_xml(request)

      business_cards, matched_count = BusinessCards.parse(response)
      business_cards.empty? ? nil : business_cards[0]
    end

    # Returns the estimated number of cards and number of pages for exporting Business Cards as PDF
    def estimate_pdf_business_card_report
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do |xml|
        connection.requester_credentials_block(xml)
        xml.EstimatePdfBusinessCardReport
      end
      response = connection.post_xml(xml)
      document = REXML::Document.new(response)
      number_of_cards = document.elements["EstimatePdfBusinessCardReportCallResponse"].elements["NumberOfBusinessCards"].text.to_i rescue 0
      number_of_pages = document.elements["EstimatePdfBusinessCardReportCallResponse"].elements["NumberOfPages"].text.to_i rescue 0
      return number_of_cards, number_of_pages
    end

    # Returns a URL for one-time download of Business Cards as PDF
    def generate_pdf_business_card_report
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do |xml|
        connection.requester_credentials_block(xml)
        xml.GeneratePdfBusinessCardReport
      end
      response = connection.post_xml(xml)
      document = REXML::Document.new(response)
      document.elements["GeneratePdfBusinessCardReportCallResponse"].elements["URL"].text
    end

    # Returns a hash of export options and whether they are enabled
    # {"DEFAULT" => true, "EVERNOTE" => true, "GOOGLE_MAIL" => true, "YAHOO_MAIL" => false}
    def get_business_card_exports
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do |xml|
        connection.requester_credentials_block(xml)
        xml.GetBusinessCardExportsCall
      end
      response = connection.post_xml(xml)
      exports = Hash.new
      document = REXML::Document.new(response)
      document.elements.collect("//Export") do |export_element|
        begin
          id = export_element.elements["Id"].text
          enabled = (export_element.elements["Enabled"].text == "true")
          exports[id] = enabled
        end
      end
      exports
    end

    # Does the user have business card auto-share mode turned on?
    def notify_preference
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do |xml|
        connection.requester_credentials_block(xml)
        xml.GetBusinessCardNotifyPreferenceCall
      end
      response = connection.post_xml(xml)
      document = REXML::Document.new(response)
      document.elements["GetBusinessCardNotifyPreferenceCallResponse"].elements["BusinessCardNotifyPreference"].text == "1"
    end

    # Turn auto-share mode on or off
    def notify_preference=(value)                          
      if value
        translated_value = "1"
      else
        translated_value = "0"
      end
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do |xml|
        connection.requester_credentials_block(xml)
        xml.SetBusinessCardNotifyPreferenceCall do |xml|
          xml.BusinessCardNotifyPreference(translated_value)
        end
      end
      response = connection.post_xml(xml)
      # TODO: Retrieve the new value to make sure it worked?
      value
    end
    
    def get_viral_business_card_email_text
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do |xml|
        connection.requester_credentials_block(xml)
        xml.GetViralBusinessCardEmailTextCall
      end
      response = connection.post_xml(xml)
      document = REXML::Document.new(response)
      document.elements["GetViralBusinessCardEmailTextCallResponse"].elements["ViralEmailText"].text
    end
    
    # Get user's contact information that is sent out with business cards
    def auto_share_contact_details
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do |xml|
        connection.requester_credentials_block(xml)
        xml.GetAutoShareContactDetailsCall
      end
      response = connection.post_xml(xml)
      details = Hash.new
      document = REXML::Document.new(response)
      details_element = document.elements["GetAutoShareContactDetailsCallResponse"]
      details[:first_name] = details_element.elements["FirstName"].text
      details[:last_name] = details_element.elements["LastName"].text
      details[:email] = details_element.elements["Email"].text
      details[:additional_contact_info] = details_element.elements["AdditionalContactInfo"].text    
      details
    end

    # Set user's contact information that is sent out with business cards 
    # value should be a hash {:first_name => "John", :last_name => "Doe", :email => "John.Doe@example.com", :additional_contact_info => "Only email on weekdays"}
    def auto_share_contact_details=(value)                          
      first_name = value[:first_name] || ''
      last_name = value[:last_name] || ''
      email = value[:email] || ''
      additional_contact_info = value[:additional_contact_info] || ''
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do |xml|
        connection.requester_credentials_block(xml)
        xml.UpdateAutoShareContactDetailsCall do |xml|
          xml.FirstName(first_name)
          xml.LastName(last_name)
          xml.Email(email)
          xml.AdditionalContactDetails(additional_contact_details)
        end
      end
      response = connection.post_xml(xml)
      # TODO: Retrieve the new value to make sure it worked?  
      # TODO: This can throw some specific efforts; see http://developer.shoeboxed.com/business-cards
      value
    end

private
    def get_business_cards
      request = build_business_card_request
      response = connection.post_xml(request)

      BusinessCards.parse(response)
    end

    def build_business_card_request(options={})
      process_options(options)

      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do |xml|
        connection.requester_credentials_block(xml)
        xml.GetBusinessCardCall do |xml|
          xml.BusinessCardFilter do |xml|
            xml.Results(per_page)
            xml.PageNo(current_page)
            xml.ModifiedSince(modified_since) if modified_since
          end
        end
      end
    end


    def build_single_business_card_request(id)
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do |xml|
        connection.requester_credentials_block(xml)
        xml.GetBusinessCardInfoCall do |xml|
          xml.BusinessCardFilter do |xml|
            xml.BusinessCardId(id)
          end
        end
      end
    end

  end
end