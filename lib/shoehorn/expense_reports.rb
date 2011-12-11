require 'rexml/document'
require 'builder'

module Shoehorn
  class ExpenseReports < Array

    attr_accessor :connection

    def initialize(connection)
      @connection = connection
      expense_reports = get_expense_reports
      super(expense_reports || [])
    end

    def refresh
      initialize(@connection)
    end

    def self.parse(xml)
      expense_reports = Array.new
      document = REXML::Document.new(xml)
      document.elements.collect("//Report") do |report_element|
        begin 
          expense_report = ExpenseReport.new
          expense_report.id = report_element.elements["Id"].text
          expense_report.name = report_element.elements["Name"].text
          expense_report.date = report_element.elements["Date"].text.to_date_from_shoeboxed_string
          expense_report.num_pages = report_element.elements["NumPages"].text.to_i
          expense_report.url = report_element.elements["URL"].text
        rescue => e
          raise Shoehorn::ParseError.new(e, report_element.to_s, "Error parsing expense report.")
        end
        expense_reports << expense_report
      end
      expense_reports
    end

private
    def get_expense_reports
      request = build_expense_report_request
      response = connection.post_xml(request)

      ExpenseReports.parse(response)
    end

    def build_expense_report_request
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.Request(:xmlns => "urn:sbx:apis:SbxBaseComponents") do |xml|
        connection.requester_credentials_block(xml)
        xml.GetPdfExpenseReportsCall
      end
    end

  end
end