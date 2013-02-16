module Shoehorn
  class Receipt
     attr_accessor :store, :id, :total, :note, :document_currency, :account_currency, :conversion_rate, :document_total, :converted_total,
      :formatted_document_total, :formatted_converted_total, :document_tax, :converted_tax, :formatted_document_tax, 
      :formatted_converted_tax, :modified_date, :created_date, :selldate, :categories, :images
  end
end