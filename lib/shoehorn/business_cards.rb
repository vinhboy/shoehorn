module Shoehorn
  class BusinessCards
    include Enumerable
    
    attr_accessor :connection

    def initialize(connection)
      @connection = connection
      @business_cards = get_business_cards
    end

    def refresh
      @business_cards = get_business_cards
    end

    def each
      @business_cards.each
    end

    def [](i)
      @business_cards[i]
    end

private
    def get_business_cards
    end

  end
end