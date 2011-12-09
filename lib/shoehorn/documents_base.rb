module Shoehorn
  class DocumentsBase
    include Enumerable

    # TODO: Can be a bit less public here when done testing, I'm sure
    attr_accessor :connection, :matched_count, :per_page, :category_id, :modified_since, :current_page, :total_pages, :pages_retrieved, :array

    def initialize_options
      unless @skip_initialize_options
        @array = Array.new
        @per_page = 50
        @category_id = nil
        @current_page = 1
        @modified_since = nil
        @total_pages = 1
        @pages_retrieved = []
      end
    end

    def refresh
      initialize(@connection)
    end

    # array methods
    def is_a?(klass)
      @array.is_a?(klass)
    end

    def inspect
      @array.inspect
    end

    def [](i)
      needed_page = (i.to_i / per_page.to_i) + 1
      if !pages_retrieved.include? needed_page
        get_pages(:from => current_page + 1, :to => needed_page)
      end
      @array[i]
    end

    def size
      @matched_count
    end

    def get_pages(options = {})
      from = options[:from] || 1
      to = options[:to] || total_pages
      from.upto(to) do |page|
        records, matched_count = get_page(page)
        @array += records
      end
    end

    def get_page
      raise InternalError.new("get_page should be implemented in all subclasses of DocumentBase")
    end

    def each
      get_pages(:from => current_page + 1, :to => total_pages)
      @array.each{|i| yield i}
    end

    def method_missing(method, *args, &block)
      @array.send(method, *args, &block)
    end

    # Requires an inserter id from an upload call
    def status(inserter_id)
      status_hash = Hash.new
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do |xml|
        connection.requester_credentials_block(xml)
        xml.GetDocumentStatusCall do |xml|
          xml.InserterId(inserter_id)
        end
      end
      response = connection.post_xml(xml)
      document = REXML::Document.new(response)
      status_hash[:status] = document.elements["GetDocumentStatusCallResponse"].elements["Status"].text
      status_hash[:document_id] = document.elements["GetDocumentStatusCallResponse"].elements["DocumentId"].text
      status_hash[:document_type] = document.elements["GetDocumentStatusCallResponse"].elements["DocumentType"].text
      status_hash
    end

    def matched_count=(value)
      if value
        @total_pages = (value.to_i / @per_page.to_i)
        @total_pages += 1 unless (value % @per_page == 0)
      end
      @matched_count = value
    end

    # Resets if changing filters
    def category_id=(value)
      if value && (value != @category_id)
        @category_id = value
        @per_page = 50
        @current_page = 1
        @modified_since = nil
        @total_pages = 1
        @pages_retrieved = []
        @skip_initialize_options = true
        initialize(@connection)
        @skip_initialize_options = false
      end
    end

    def modified_since=(value)
      return if value.nil?

      if value.is_a? String
        value_date = Date.new(*Date._parse(value, false).values_at(:year, :mon, :mday))
      elsif value.is_a? DateTime
        value_date = Date.new(value.year, value.month, value.day)
      elsif value.is_a? Date
        value_date = value
      else
        raise Shoehorn::ParameterError
      end

      value_string = value_date.strftime('%m/%d/%Y')

      if value_string && (value_string != @modified_since)
        @modified_since = value_string
        @per_page = 50
        @category_id = nil
        @current_page = 1
        @total_pages = 1
        @pages_retrieved = []
        @skip_initialize_options = true
        initialize(@connection)
        @skip_initialize_options = false
      end
    end

    def per_page=(value)
      if per_page && (value != @per_page)
        @per_page = value
        @category_id = nil
        @current_page = 1
        @modified_since = nil
        @total_pages = 1
        @pages_retrieved = []
        @skip_initialize_options = true
        initialize(@connection)
        @skip_initialize_options = false
      end
    end

    def process_options(options={})
      results = options[:per_page] || per_page
      page_no = options[:page] || current_page
      modified_since = options[:modified_since] || modified_since
      category_id = options[:category_id] || category_id
    end

    # Returns true if we're dealing with anything other than all the records
    def filtered?
      !(modified_since || category_id).nil?
    end

  end
end