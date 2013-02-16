# shoehorn

An implementation of the Shoeboxed (https://app.shoeboxed.com/) API. Consult the Shoeboxed API documentation (http://developer.shoeboxed.com/overview) for details of API operations.

## Installation

  gem install shoehorn

## What's Implemented

### Connecting to Shoeboxed

In general, using Shoeboxed requires three things:

* An application name
* An application token
* A user token

The first two are supplied by Shoeboxed - you can find them in your Account & Settings page on the Shoeboxed site under "API Keys and Info." The third must be retrieved by running the user through an authentication process.

Start the process by initializing shoehorn with your application information:

  connection = Shoehorn::Connection.new('MyAppName', 'my_app_token', 'http://myapp.example.com', {:param => 'value'})

The third and fourth parameters define the callback URL that your application must listen to for the user token. You can supply a base URL and a set of querystring parameters that will be returned.

Next, retrieve connection.authentication_url from shoehorn. Send your user to this URL. If they choose to authorize your application's use of their Shoeboxed data, you'll get a call back on the supplied URL with your supplied parameters plus two more:

* tkn will be the user token
* uname will be the username on Shoeboxed

Finally, save the user token on your shoehorn connection. This sets the user context for all subsequent shoehorn calls.

  connection.user_token = tkn

See http://developer.shoeboxed.com/authentication for further details on the Shoeboxed authentication process.

### Retrieving data

After successfully authenticating, you can retrieve the user's Shoeboxed data from collections on the connection:

  connection.Bills
  connection.BusinessCards
  connection.Categories
  connection.ExpenseReports
  connection.OtherDocuments
  connection.Receipts

These collections are lazily initialized when they are first accessed. Each also supports a refresh method to update the data from Shoeboxed. Within the collections you'll find individual objects - Bill, BusinessCard, Category, ExpenseReport, OtherDocument, Receipt - containing the details of the data.

Although Shoeboxed returns collections in batches, this should be transparent to the calling application. In particular, things like Bills[123] and Receipts.each do |r| will retrieve all the pages of data that they need in the background as they are run. You may find some other array methods offer unexpected results. Please post a GitHub issue or send a pull request if you need one of these fixed.

If you know the ID of a particular document on Shoeboxed, you can retrieve it directly with the find_by_id method on the appropriate collection:

  bill = connection.bills.find_by_id("123884")

**NOTE: The find\_by\_id method is not supported on expense reports.**

### Utility methods

Some other parts of the Shoeboxed API are also covered by this gem:

* BusinessCards
  * estimate\_pdf\_business\_card\_report - returns the estimated number of cards and pages for exporting business cards as a PDF.
  * generate\_pdf\_business\_card\_report - Returns a URL for one-time download of business cards as a PDF.
  * get\_business\_card\_exports - Returns a hash of export options and whether they are enabled.
  * notify\_preferences - Get or set the user's auto-share mode.
  * get\_viral\_business\_card\_email\_text
  * auto\_share\_contact\_details - Get or set the user's contact information that is sent out with business cards

## What's Missing

* Upload support
* Cover sheet support
* Live sandbox testing (This is not yet implemented by Shoeboxed)

## Testing Shoehorn

Some of the tests depend on a live connection to Shoeboxed. To set this up, you must make a copy of test/shoehorn\_credentials.sample.yml to test/shoehorn\_credentials.yml and fill in the required information.

## Footnotes

Author: Mike Gunderloy, MikeG1@larkfarm.com

Thanks to https://github.com/bcurren/rshoeboxed for previous hard work on the Shoeboxed API. Some portions of this code originated with rshoeboxed.

Thanks to Austin Che[https://github.com/austinche] and Matt Gaidica[https://github.com/mattgaidica] for bug fixes.

Public repo: https://github.com/ffmike/shoehorn