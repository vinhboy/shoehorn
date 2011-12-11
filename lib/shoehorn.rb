require 'rexml/document'
require 'builder'

class String
  def to_date_from_shoeboxed_string
    return nil if self.nil?
    begin
      Date.parse(self, false)
    rescue Exception => ex
      nil
    end
  end
end

require 'shoehorn/errors'
require 'shoehorn/connection'
require 'shoehorn/documents_base'
require 'shoehorn/bills'
require 'shoehorn/bill'
require 'shoehorn/business_cards'
require 'shoehorn/business_card'
require 'shoehorn/categories'
require 'shoehorn/category'
require 'shoehorn/expense_reports'
require 'shoehorn/expense_report'
require 'shoehorn/images'
require 'shoehorn/image'
require 'shoehorn/other_documents'
require 'shoehorn/other_document'
require 'shoehorn/receipts'
require 'shoehorn/receipt'
