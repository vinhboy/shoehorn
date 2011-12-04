module Shoehorn
  class OtherDocuments
    include Enumerable
    
    attr_accessor :connection

    def initialize(connection)
      @connection = connection
      @other_documents = get_other_documents
    end

    def refresh
      @other_documents = get_other_documents
    end

    def each
      @other_documents.each
    end

    def [](i)
      @other_documents[i]
    end

private
    def get_other_documents
    end

  end
end