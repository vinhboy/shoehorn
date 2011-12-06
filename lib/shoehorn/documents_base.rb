module Shoehorn
  class DocumentsBase  < Array
   
    attr_accessor :connection, :matched_count, :status

    def refresh
      initialize(@connection)
    end

  end
end