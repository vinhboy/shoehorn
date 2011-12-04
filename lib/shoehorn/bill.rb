module Shoehorn
  class Bill
    attr_accessor :id, :envelope_code, :note, :create_date, :modify_date, :name, :document_currency, :account_currency,
      :document_total, :converted_total, :formatted_document_total, :formatted_converted_total, :images
  end
end