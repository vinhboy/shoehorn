require 'cgi'
require 'iconv'
require 'logger'
require "net/https"

module Shoehorn
  class Connection

    API_SERVER = "api.shoeboxed.com"
    API_VERSION = 1   
    API_PATH = "/v#{API_VERSION}/ws/api.htm"
    API_ENDPOINT = "https://#{API_SERVER}#{API_PATH}"

    attr_accessor :application_name, :return_url, :return_parameters, :application_token, :user_token

    def initialize()
      setup_logger
    end

    def initialize(application_name = nil, application_token = nil, return_url = nil, return_parameters = nil)
      setup_logger
      @application_name = application_name if application_name      
      @application_token = application_token if application_token
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
 
    def requester_credentials_block(xml)
      xml.RequesterCredentials do |xml|
        xml.ApiUserToken(@application_token)
        xml.SbxUserToken(@user_token)
      end
    end

    def post_xml(body)
      connection = Net::HTTP.new(API_SERVER, 443)
      connection.use_ssl = true
      connection.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(API_PATH)
      request.set_form_data({'xml'=>body})

      result = connection.start  { |http| http.request(request) }

      # Convert to UTF-8, shoeboxed encodes with ISO-8859-1
      result_body = Iconv.conv('UTF-8', 'ISO-8859-1', result.body)

      if logger.debug?
        logger.debug "Request:"
        logger.debug body
        logger.debug "Response:"
        logger.debug result_body
      end

      check_for_api_error(result_body)
    end
    
    def check_for_api_error(body)
      document = REXML::Document.new(body)
      root = document.root
      puts root.inspect
      if root && root.name == "Error"
        description = root.attributes["description"]
        
        case root.attributes["code"]
        when "1"
          raise AuthenticationError.new(description)
        when "2"
          raise UnknownAPICallError.new(description)
        when "3"
          raise RestrictedIPError.new(description)
        when "4"
          raise XMLValidationError.new(description)
        when "5"
          raise InternalError.new(description)
        end
      end
      
      body
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