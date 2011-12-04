module Shoehorn
  class Bills
    include Enumerable

    def initialize
      @bills = get_bills
    end

    def refresh
      @bills = get_bills
    end

    def each
      @bills.each
    end

    def [](i)
      @bills[i]
    end

private
    def get_bills
    end

  end
end