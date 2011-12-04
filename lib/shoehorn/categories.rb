module Shoehorn
  class Categories
    include Enumerable        
    
    attr_accessor :connection

    def initialize(connection)
      @connection = connection
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