require 'logger'

module Shoehorn
  class Connection

    API_VERSION = 1
    API_ENDPOINT = "https://api.shoeboxed.com/v#{API_VERSION}/ws/api.htm"

    def initialize
      setup_logger
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

  end
end