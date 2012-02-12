require 'rubygems'
require File.dirname(__FILE__) + '/../lib/shoehorn'

require 'test/unit'
require 'shoulda'
require 'mocha'
require 'yaml'
require 'fakeweb'

class ShoehornTest < Test::Unit::TestCase
  include Shoehorn

  def live_connection
    config = YAML.load_file(File.dirname(__FILE__) + '/shoehorn_credentials.yml')
    application_token = config["credentials"]["application_token"]
    application_name = config["credentials"]["application_name"]
    user_name = config["credentials"]["user_name"]
    user_token = config["credentials"]["user_token"]

    connection = Shoehorn::Connection.new(application_name, application_token)
    connection.user_token = user_token
    connection
  end

  def files_path
    File.dirname(__FILE__) + '/fixtures'
  end

  def file_contents(filename)
    File.read(File.join(files_path, filename))
  end

  def mock_response(filename)
    connection = Shoehorn::Connection.new
    FakeWeb.register_uri(:post, Shoehorn::Connection::API_ENDPOINT, :body => file_contents(filename))
    connection
  end

  # Prevent T::U from identifying this as a test file with no tests in it
  context "sample" do
    should "assert truth" do
      assert true
    end
  end

end

