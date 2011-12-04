require 'rexml/document'
require 'builder'

module Shoehorn
  class Images
    include Enumerable

    # attr_accessor :connection
    # 
    # def initialize(connection)
    #   @connection = connection
    #   @categories = get_categories
    # end
    # 
    # def refresh
    #   @categories = get_categories
    # end

    def each
      @images.each
    end

    def [](i)
      @images[i]
    end

    def self.parse(xml) 
      images = Array.new
      document = REXML::Document.new(xml)
      document.elements.collect("//Image") do |image_element|
        begin
          image = Image.new(image_element.attributes["imgurl"], image_element.attributes["index"])
        rescue => e
          raise Shoehorn::ParseError.new(e, image_element.to_s, "Error parsing image.")
        end
        images << image
      end
      images
    end

  end
end