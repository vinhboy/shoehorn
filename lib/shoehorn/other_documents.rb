module Shoehorn
  class OtherDocuments < Array
    
    attr_accessor :connection

    def initialize(connection)
      @connection = connection
      other_documents = get_other_documents
      other_documents.nil? ? super([]) : super(other_documents)
    end

    def refresh
      initialize(@connection)
    end

private
    def get_other_documents
    end

  end
end