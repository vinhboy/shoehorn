module Shoehorn
  class Bill
    # NOTE: conversion_rate is not documented at http://developer.shoeboxed.com/bill-object 
    # but it appears in the sample response at http://developer.shoeboxed.com/bills
    attr_accessor :id, :envelope_code, :note, :create_date, :modify_date, :name, :document_currency, :account_currency,
      :document_total, :converted_total, :formatted_document_total, :formatted_converted_total, :images, :conversion_rate
  end
end