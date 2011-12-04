module Shoehorn
  class BusinessCards
    include Enumerable

    def initialize
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