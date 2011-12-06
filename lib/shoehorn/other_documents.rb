module Shoehorn
  class OtherDocuments < Array

    attr_accessor :connection, :matched_count

    def initialize(connection)
      @connection = connection
      other_documents, @matched_count = get_other_documents
      super(other_documents || [])
    end

    def refresh
      initialize(@connection)
    end

    def self.parse(xml)
      other_documents = Array.new
      document = REXML::Document.new(xml)
      if document.elements["GetOtherDocumentCallResponse"]
        matched_count = document.elements["GetOtherDocumentCallResponse"].elements["OtherDocuments"].attributes["count"].to_i rescue 1
      end
      document.elements.collect("//OtherDocument") do |other_document_element|
        begin
          other_document = OtherDocument.new
          other_document.id = other_document_element.attributes["id"]
          other_document.envelope_code = other_document_element.attributes["envelopeCode"]
          other_document.note = other_document_element.attributes["note"]
          other_document.create_date = other_document_element.attributes["createDate"]
          other_document.modify_date = other_document_element.attributes["modifyDate"]
          other_document.name = other_document_element.attributes["name"]

          image_element = other_document_element.elements["Images"]
          other_document.images = image_element ? Images.parse(image_element.to_s) : []
        rescue => e
          raise Shoehorn::ParseError.new(e, other_document_element.to_s, "Error parsing other document.")
        end
        other_documents << other_document
      end
      return other_documents, matched_count
    end

    def find_by_id(id)
      request = build_single_other_document_request(id)
      response = connection.post_xml(request)

      other_documents, matched_count = OtherDocuments.parse(response)
      other_documents.empty? ? nil : other_documents[0]
    end

private
    def get_other_documents
      request = build_other_document_request
      response = connection.post_xml(request)

      OtherDocuments.parse(response)
    end

    def build_other_document_request(options={})
      results = options[:per_page] || 50
      page_no = options[:page] || 1
      modified_since = options[:modified_since]

      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do |xml|
        connection.requester_credentials_block(xml)
        xml.GetOtherDocumentCall do |xml|
          xml.OtherDocumentFilter do |xml|
            xml.Results(results)
            xml.PageNo(page_no)
            xml.ModifiedSince(modified_since) if modified_since
          end
        end
      end
    end

    def build_single_other_document_request(id)
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do |xml|
        connection.requester_credentials_block(xml)
        xml.GetOtherDocumentInfoCall do |xml|
          xml.OtherDocumentFilter do |xml|
            xml.OtherDocumentId(id)
          end
        end
      end
    end

  end
end