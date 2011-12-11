module Shoehorn
  class Bills < DocumentsBase

    def initialize(connection)
      @connection = connection
      initialize_options
      bills, self.matched_count = get_page(1)
      @array = bills || []
    end

    def self.parse(xml)
      bills = Array.new
      document = REXML::Document.new(xml)
      if document.elements["GetBillCallResponse"]
        matched_count = document.elements["GetBillCallResponse"].elements["Bills"].attributes["count"].to_i rescue 1
      end
      document.elements.collect("//Bill") do |bill_element|
        begin
          bill = Bill.new
          bill.id = bill_element.attributes["id"]
          bill.envelope_code = bill_element.attributes["envelopeCode"]
          bill.note = bill_element.attributes["note"]
          bill.create_date = bill_element.attributes["createDate"].to_date_from_shoeboxed_string
          bill.modify_date = bill_element.attributes["modifyDate"].to_date_from_shoeboxed_string
          bill.name = bill_element.attributes["name"]
          bill.conversion_rate = bill_element.attributes["conversionRate"].to_f
          bill.document_currency = bill_element.attributes["documentCurrency"]
          bill.account_currency = bill_element.attributes["accountCurrency"]
          bill.document_total = bill_element.attributes["documentTotal"].to_f
          bill.converted_total = bill_element.attributes["convertedTotal"].to_f
          bill.formatted_document_total = bill_element.attributes["formattedDocumentTotal"]
          bill.formatted_converted_total = bill_element.attributes["formattedConvertedTotal"]

          image_element = bill_element.elements["Images"]
          bill.images = image_element ? Images.parse(image_element.to_s) : []
        rescue => e
          raise Shoehorn::ParseError.new(e, bill_element.to_s, "Error parsing bill.")
        end
        bills << bill
      end
      return bills, matched_count
    end

    def find_by_id(id)
      request = build_single_bill_request(id)
      response = connection.post_xml(request)

      bills, matched_count = Bills.parse(response)
      bills.empty? ? nil : bills[0]
    end

    def get_page(i)
      current_page = i
      request = build_bill_request
      response = connection.post_xml(request)
      pages_retrieved << current_page

      Bills.parse(response)
    end

private
    def build_bill_request(options={})
      process_options(options)

      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do |xml|
        connection.requester_credentials_block(xml)
        xml.GetBillCall do |xml|
          xml.BillFilter do |xml|
            xml.Results(per_page)
            xml.PageNo(current_page)
            xml.ModifiedSince(modified_since) if modified_since
          end
        end
      end
    end

    def build_single_bill_request(id)
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do |xml|
        connection.requester_credentials_block(xml)
        xml.GetBillInfoCall do |xml|
          xml.BillFilter do |xml|
            xml.BillId(id)
          end
        end
      end
    end

  end
end