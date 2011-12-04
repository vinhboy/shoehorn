module Shoehorn
  class Bills < Array

    attr_accessor :connection, :matched_count

    def initialize(connection)
      @connection = connection
      bills, @matched_count = get_bills
      super(bills || [])
    end

    def refresh
      initialize(@connection)
    end

    def self.parse(xml)
      bills = Array.new
      document = REXML::Document.new(xml)
      matched_count = document.elements["GetBillCallResponse"].elements["Bills"].attributes["count"].to_i rescue 1
      document.elements.collect("//Bill") do |bill_element|
        begin
          bill = Bill.new
          bill.id = bill_element.attributes["id"]
          bill.envelope_code = bill_element.attributes["envelopeCode"]
          bill.note = bill_element.attributes["note"]
          bill.create_date = bill_element.attributes["createDate"]
          bill.modify_date = bill_element.attributes["modifyDate"]
          bill.name = bill_element.attributes["name"]
          bill.conversion_rate = bill_element.attributes["conversionRate"]
          bill.document_currency = bill_element.attributes["documentCurrency"]
          bill.account_currency = bill_element.attributes["accountCurrency"]
          bill.document_total = bill_element.attributes["documentTotal"]
          bill.converted_total = bill_element.attributes["convertedTotal"]
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

private
  def get_bills
    request = build_bill_request
    response = connection.post_xml(request)

    Bills.parse(response)
  end

  def build_bill_request(options={})
    results = options[:per_page] || 50
    page_no = options[:page] || 1
    modified_since = options[:modified_since]

    xml = Builder::XmlMarkup.new
    xml.instruct!
    xml.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do |xml|
      connection.requester_credentials_block(xml)
      xml.GetBillCall do |xml|
        xml.BillFilter do |xml|
          xml.Results(results)
          xml.PageNo(page_no)
          xml.ModifiedSince(modified_since) if modified_since
        end
      end
    end

  end

  end
end