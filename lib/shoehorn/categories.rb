module Shoehorn
  class Categories
    include Enumerable

    def initialize
      @categories = get_categories
    end

    def refresh
      @categories = get_categories
    end

    def each
      @categories.each
    end

    def [](i)
      @categories[i]
    end

private
    def get_categories
    end

  end
end