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