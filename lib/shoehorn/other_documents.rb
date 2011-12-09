module Shoehorn
  class OtherDocuments < DocumentsBase

    def initialize(connection)
      @connection = connection
      initialize_options
      other_documents, self.matched_count = get_page(1)
      @array = other_documents || []
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

    def get_page(i)
      current_page = i
      request = build_other_document_request
      response = connection.post_xml(request)
      pages_retrieved << current_page

      OtherDocuments.parse(response)
    end

private
    def build_other_document_request(options={})
      process_options(options)

      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do |xml|
        connection.requester_credentials_block(xml)
        xml.GetOtherDocumentCall do |xml|
          xml.OtherDocumentFilter do |xml|
            xml.Results(per_page)
            xml.PageNo(current_page)
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