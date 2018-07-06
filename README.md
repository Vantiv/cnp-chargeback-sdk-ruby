# cnp-chargeback-sdk-ruby
Ruby SDK implementing Vantiv eCommerce Chargeback API

About Vantiv eCommerce
------------
[Vantiv eCommerce](https://developer.vantiv.com/community/ecommerce) powers the payment processing engines for leading companies that sell directly to consumers through  internet retail, direct response marketing (TV, radio and telephone), and online services. Vantiv eCommerce is the leading authority in card-not-present (CNP) commerce, transaction processing and merchant services.

About this SDK
--------------
The Vantiv eCommerce Ruby Chargeback SDK is a Ruby implementation of the [Vantiv eCommerce](https://developer.vantiv.com/community/ecommerce) Chargeback API. This SDK was created to make it as easy as possible to manage your chargebacks using Vantiv eCommerce API. This SDK utilizes the HTTPS protocol to securely connect to Vantiv eCommerce. Using the SDK requires coordination with the Vantiv eCommerce team in order to be provided with credentials for accessing our systems.

Each Ruby Chargeback SDK release supports all of the functionality present in the associated Vantiv eCommerce Chargeback API version (e.g., SDK v2.1.0 supports Vantiv eCommerce Chargeback API v2.1). Please see the Chargeback API reference guide to get more details on what the Vantiv eCommerce chargeback engine supports.

See LICENSE file for details on using this software.

Source Code available from : [https://github.com/Vantiv/cnp-sdk-for-ruby](https://github.com/Vantiv/cnp-chargeback-sdk-ruby)

Please contact [Vantiv eCommerce](https://developer.vantiv.com/community/ecommerce) to receive valid merchant credentials in order to run tests successfully or if you require assistance in any way.  We are reachable at sdksupport@Vantiv.com


Setup
-----

1) Install the CnpChargeback Ruby gem from rubygems.org, this will install the latest SDK gem in your Ruby environment.
Our gem is available publicly from rubygems.org.  Use the command below to install.

>sudo gem install CnpChargeback

Note: If you get errors, you might have to configure your proxy.

2) Once the gem is installed run our setup program to generate a configuration file.  The configuration file resides in your home directory
$HOME/.cnp_chargeback_config.yml

For more details on setup see our instructions [here](https://github.com/Vantiv/cnp-sdk-for-ruby/blob/12.X/SETUP.md)

3) Example usage: 

```ruby
require 'CnpChargeback'
include CnpChargeback

# Retrieving information about a chargeback by caseId:
response = ChargebackRetrieval.new.get_chargeback_by_case_id(case_id: "123")
#access response elements 
transactionId = response.transactionId
cycle = response.cycle

# Retrieving a list of chargebacks by activity date
response = ChargebackRetrieval.new.get_chargebacks_by_date(activity_date: "2018-01-01")
# access response elements 
transactionId = response[5].transactionId
cycle = response[3].cycle
 
# Update chargeback case
ChargebackUpdate.new.represent_case(case_id: 10000, note: "Test note", representment_amount: 12000)
response = ChargebackUpdate.new.assign_case_to_user(case_id: 10000, user_id: "jdeo@company.com", note: "Test note")
 
# Upload document
response = ChargebackDocument.new.upload_document(case_id: "10000", document_path: "invoice.pdf")
response_code = response.responseCode

# Retrieve a list of documents by case id
response = ChargebackDocument.new.list_documents(case_id: "10000")
document_list = response.documentId
```


Please contact Vantiv eCommerce with any further questions. You can reach us at sdksupport@vantiv.com.


