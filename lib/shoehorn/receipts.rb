module Shoehorn
  class Receipts
    include Enumerable

    def initialize
      @receipts = get_receipts
    end

    def refresh
      @receipts = get_receipts
    end

    def each
      @receipts.each
    end

    def [](i)
      @receipts[i]
    end

private
    def get_receipts
    end

  end
end