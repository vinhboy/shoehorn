require 'cgi'
require 'logger'

module Shoehorn
  class Connection

    API_VERSION = 1
    API_ENDPOINT = "https://api.shoeboxed.com/v#{API_VERSION}/ws/api.htm"

    attr_accessor :application_name, :return_url, :return_parameters

    def initialize()
      setup_logger
    end

    def initialize(application_name = nil, return_url = nil, return_parameters = nil)
      setup_logger
      @application_name = application_name if application_name
      @return_url = return_url if return_url
      @return_parameters = encode_parameters(return_parameters) if return_parameters
    end

    def authentication_url
      raise ParameterError.new("Authentication URL requires application name")if application_name.nil?
      raise ParameterError.new("Authentication URL requires return URL") if return_url.nil?
      "#{API_ENDPOINT}?appname=#{@application_name}&appurl=#{CGI.escape(@return_url)}&apparams=#{@return_parameters}&SignIn=1"
    end

    def bills
      unless @bills_initialized
        @bills = Shoehorn::Bills.new(self)
        @bills_initialized = true
      end
      @bills
    end

    def business_cards
      unless @business_cards_initialized
        @business_cards = Shoehorn::BusinessCards.new(self)
        @business_cards_initialized = true
      end
      @business_cards
    end

    def categories
      unless @categories_initialized
        @categories = Shoehorn::Categories.new(self)
        @categories_initialized = true
      end
      @categories
    end

    def other_documents
      unless @other_documents_initialized
        @other_documents = Shoehorn::OtherDocuments.new(self)
        @other_documents_initialized = true
      end
      @other_documents
    end

    def receipts
      unless @receipts_initialized
        @receipts = Shoehorn::Receipts.new(self)
        @receipts_initialized = true
      end
      @receipts
    end

    def logger
      @@logger
    end

    def logger=(new_logger)
      @@logger = new_logger
    end

    def log_level=(level)
      @@logger.level = level
    end

    def log_level
      @@logger.level
    end

private
    def setup_logger
      @@logger = Logger.new(STDOUT)
      @@logger.level = Logger::WARN
    end

    def encode_parameters(params)
      if params.kind_of? String
        params
      else
        encoded_params = params.collect do |name, value|
          "#{CGI.escape(name.to_s)}=#{CGI.escape(value.to_s)}"
        end
        encoded_params.join("&")
      end
    end

  end
end