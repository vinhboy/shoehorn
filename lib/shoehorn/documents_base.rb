module Shoehorn
  class DocumentsBase  < Array

    attr_accessor :connection, :matched_count

    def refresh
      initialize(@connection)
    end

    # Requires an inserter id from an upload call
    def status(inserter_id)
      status_hash = Hash.new
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do |xml|
        connection.requester_credentials_block(xml)
        xml.GetDocumentStatusCall do |xml|
          xml.InserterId(inserter_id)
        end
      end
      response = connection.post_xml(xml)
      document = REXML::Document.new(response)
      status_hash[:status] = document.elements["GetDocumentStatusCallResponse"].elements["Status"].text
      status_hash[:document_id] = document.elements["GetDocumentStatusCallResponse"].elements["DocumentId"].text
      status_hash[:document_type] = document.elements["GetDocumentStatusCallResponse"].elements["DocumentType"].text
      status_hash
    end

  end
end