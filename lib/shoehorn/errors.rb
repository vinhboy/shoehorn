module Shoehorn
  class AuthenticationError < StandardError; end;
  class InternalError < StandardError; end;
  class ParameterError < StandardError; end 
  class ParseError < StandardError; end
  class RestrictedIPError < StandardError; end;
  class UnknownAPICallError < StandardError; end;
  class XMLValidationError < StandardError; end;
end
