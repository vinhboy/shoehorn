# shoehorn

An implementation of the Shoeboxed (https://app.shoeboxed.com/) API. Consult the Shoeboxed API documentation (http://developer.shoeboxed.com/overview) for details of API operations.

## Supported Methods

## Not yet Supported Methods

GetDocumentStatusCall  
UploadCall  
GetBillCall  
GetBillInfoCall  
GetBusinessCardCall  
GetBusinessCardInfoCall  
GetBusinessCardStatusCall  
EstimatePdfBusinessCardReportCall  
GeneratePdfBusinessCardReportCall  
GetBusinessCardExportsCall  
GetBusinessCardNotifyPreferenceCall  
SetBusinessCardNotifyPreferenceCall  
GetViralBusinessCardEmailTextCall  
GetAutoShareContactDetailsCall  
UpdateAutoShareContactDetailsCall  
GetCategoryCall  
CreateUserCategoryCall  
GenerateCoversheetCall  
GetPdfExpenseReportsCall  
GetOtherDocumentCall  
GetOtherDocumentInfoCall   
GetReceiptCall  
GetReceiptInfoCall  
GetReceiptStatusCall   
ClaimAnonymousAccountCall  
CreateFreeTrialCall  
GetNewAnonymousUserCall  
GetFreeTrialsAvailableCall  
GetNumberFreeMobileCreditsCall  
GetUserStatisticsCall  
RegisterDiyUserCall  
GetLoginCall  

## Testing Shoehorn

Some of the tests depend on a live connection to Shoeboxed. To set this up, you must make a copy of test/shoehorn\_credentials.sample.yml to test/shoehorn\_credentials.yml and fill in the required information. 

## Footnotes

Mike Gunderloy, MikeG1@larkfarm.com

Thanks to https://github.com/bcurren/rshoeboxed for previous hard work on the shoeboxed API.

Public repo: https://github.com/ffmike/shoehorn