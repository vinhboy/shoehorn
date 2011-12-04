module Shoehorn
  class Bills < Array
    
    attr_accessor :connection

    def initialize(connection)
      @connection = connection
      bills = get_bills 
      bills.nil? ? super([]) : super(bills)
    end

    def refresh
      initialize(@connection)
    end

private
    def get_bills
    end

  end
end