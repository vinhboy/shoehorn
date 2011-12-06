require File.dirname(__FILE__) + '/test_helper.rb'

class ExpenseReportsTest < ShoehornTest

  context "initialization" do
    setup do
      @connection = live_connection
      @expense_reports = @connection.expense_reports
    end

    should "have a pointer back to the connection" do
      assert_equal @connection, @expense_reports.connection
    end

    should "return an array of expense reports" do
      assert @expense_reports.is_a?(Array)
    end
  end

  context "parsing" do
    should "retrieve a list of expense reports" do
      connection = mock_response('get_pdf_expense_reports_call_response.xml')
      expense_reports = connection.expense_reports
      assert_equal 2, expense_reports.size
      assert_equal "1902938", expense_reports[0].id
      assert_equal "Vacation Expenses", expense_reports[0].name
      assert_equal "07/11/2011", expense_reports[0].date
      assert_equal 3, expense_reports[0].num_pages
      assert_equal "https://app.shoeboxed.com/api/export/pdf-expenses/1902938/851d1b6e82b1d28b1cef6f9f6eebbb19", expense_reports[0].url
    end
  end

end
