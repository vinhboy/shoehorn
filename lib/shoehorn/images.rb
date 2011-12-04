require 'rexml/document'
require 'builder'

module Shoehorn
  class Images < Array

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