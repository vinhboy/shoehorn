require 'rexml/document'
require 'builder'

module Shoehorn
  class Categories < Array

    attr_accessor :connection

    def initialize(connection)
      @connection = connection
      categories = get_categories
      categories.nil? ? super([]) : super(categories)
    end

    def refresh
      initialize(@connection)
    end

    def self.parse(xml)
      categories = Array.new
      document = REXML::Document.new(xml)
      document.elements.collect("//Category") do |category_element|
        begin
          category = Category.new(category_element.attributes["id"], category_element.attributes["name"])
        rescue => e
          raise Shoehorn::ParseError.new(e, category_element.to_s, "Error parsing category.")
        end
        categories << category
      end
      categories
    end

private
    def get_categories
      request = build_category_request
      response = connection.post_xml(request)

      Categories.parse(response)
    end

    def build_category_request
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do |xml|
        connection.requester_credentials_block(xml)
        xml.GetCategoryCall
      end
    end

  end
end