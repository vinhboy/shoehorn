module Shoehorn
  class BusinessCards  < Array
    
    attr_accessor :connection

    def initialize(connection)
      @connection = connection
      business_cards = get_business_cards
      super(business_cards || [])
    end

    def refresh
      initialize(@connection)
    end

private
    def get_business_cards
    end

  end
end