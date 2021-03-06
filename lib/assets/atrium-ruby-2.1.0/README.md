# atrium-ruby

Atrium - the Ruby gem for the MX API

The MX Atrium API supports over 48,000 data connections to thousands of financial institutions. It provides secure access to your users' accounts and transactions with industry-leading cleansing, categorization, and classification.  Atrium is designed according to resource-oriented REST architecture and responds with JSON bodies and HTTP response codes.  Use Atrium's development environment, vestibule.mx.com, to quickly get up and running. The development environment limits are 100 users, 25 members per user, and access to the top 15 institutions. Contact MX to purchase production access. 

## Installation

### Build a gem

To build the Ruby code into a gem:

```shell
gem build atrium-ruby.gemspec
```

Then either install the gem locally:

```shell
gem install ./atrium-ruby-2.1.0.gem
```

Finally add this to the Gemfile:

    gem 'atrium-ruby', '~> 2.1.0'

### Install from Git

Add the following in the Gemfile:

    gem 'atrium-ruby', :git => 'https://github.com/mxenabled/atrium-ruby.git'

### Include the Ruby code directly

Include the Ruby code directly using `-I` as follows:

```shell
ruby -Ilib script.rb
```

## Example Usage

Please see `docs` directory for additional endpoint examples
```ruby
# Load the gem
require 'atrium-ruby'

client = Atrium::AtriumClient.new("YOUR_API_KEY", "YOUR_CLIENT_ID")

account_guid = "ACT-123" # String | The unique identifier for an `account`.
user_guid = "USR-123" # String | The unique identifier for a `user`.
opts = { 
  from_date: "2016-09-20", # String | Filter transactions from this date.
  to_date: "2016-10-20" # String | Filter transactions to this date.
  page: 1, # Integer | Specify current page.
  records_per_page: 12, # Integer | Specify records per page.
}

begin
  #List account transactions
  response = client.accounts.list_account_transactions(account_guid, user_guid, opts)
  p response
rescue Atrium::ApiError => e
  puts "Exception when calling AccountsApi->list_account_transactions: #{e}"
end

```

## Documentation for API Endpoints

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
*Atrium::AccountsApi* | [**list_account_transactions**](docs/AccountsApi.md#list_account_transactions) | **GET** /users/{user_guid}/accounts/{account_guid}/transactions | List account transactions
*Atrium::AccountsApi* | [**list_user_accounts**](docs/AccountsApi.md#list_user_accounts) | **GET** /users/{user_guid}/accounts | List accounts for a user
*Atrium::AccountsApi* | [**read_account**](docs/AccountsApi.md#read_account) | **GET** /users/{user_guid}/accounts/{account_guid} | Read an account
*Atrium::AccountsApi* | [**read_account_by_member_guid**](docs/AccountsApi.md#read_account_by_member_guid) | **GET** /users/{user_guid}/members/{member_guid}/accounts/{account_guid} | Read an account
*Atrium::ConnectWidgetApi* | [**get_connect_widget**](docs/ConnectWidgetApi.md#get_connect_widget) | **POST** /users/{user_guid}/connect_widget_url | Embedding in a website
*Atrium::HoldingsApi* | [**list_holdings**](docs/HoldingsApi.md#list_holdings) | **GET** /users/{user_guid}/holdings | List holdings
*Atrium::HoldingsApi* | [**list_holdings_by_account**](docs/HoldingsApi.md#list_holdings_by_account) | **GET** /users/{user_guid}/accounts/{account_guid}/holdings | List holdings by account
*Atrium::HoldingsApi* | [**list_holdings_by_member**](docs/HoldingsApi.md#list_holdings_by_member) | **GET** /users/{user_guid}/members/{member_guid}/holdings | List holdings by member
*Atrium::HoldingsApi* | [**read_holding**](docs/HoldingsApi.md#read_holding) | **GET** /users/{user_guid}/holdings/{holding_guid} | Read holding
*Atrium::IdentityApi* | [**identify_member**](docs/IdentityApi.md#identify_member) | **POST** /users/{user_guid}/members/{member_guid}/identify | Identify
*Atrium::IdentityApi* | [**list_account_owners**](docs/IdentityApi.md#list_account_owners) | **GET** /users/{user_guid}/members/{member_guid}/account_owners | List member account owners
*Atrium::InstitutionsApi* | [**list_institutions**](docs/InstitutionsApi.md#list_institutions) | **GET** /institutions | List institutions
*Atrium::InstitutionsApi* | [**read_institution**](docs/InstitutionsApi.md#read_institution) | **GET** /institutions/{institution_code} | Read institution
*Atrium::InstitutionsApi* | [**read_institution_credentials**](docs/InstitutionsApi.md#read_institution_credentials) | **GET** /institutions/{institution_code}/credentials | Read institution credentials
*Atrium::MembersApi* | [**aggregate_member**](docs/MembersApi.md#aggregate_member) | **POST** /users/{user_guid}/members/{member_guid}/aggregate | Aggregate member
*Atrium::MembersApi* | [**create_member**](docs/MembersApi.md#create_member) | **POST** /users/{user_guid}/members | Create member
*Atrium::MembersApi* | [**delete_member**](docs/MembersApi.md#delete_member) | **DELETE** /users/{user_guid}/members/{member_guid} | Delete member
*Atrium::MembersApi* | [**list_member_accounts**](docs/MembersApi.md#list_member_accounts) | **GET** /users/{user_guid}/members/{member_guid}/accounts | List member accounts
*Atrium::MembersApi* | [**list_member_credentials**](docs/MembersApi.md#list_member_credentials) | **GET** /users/{user_guid}/members/{member_guid}/credentials | List member credentials
*Atrium::MembersApi* | [**list_member_mfa_challenges**](docs/MembersApi.md#list_member_mfa_challenges) | **GET** /users/{user_guid}/members/{member_guid}/challenges | List member MFA challenges
*Atrium::MembersApi* | [**list_member_transactions**](docs/MembersApi.md#list_member_transactions) | **GET** /users/{user_guid}/members/{member_guid}/transactions | List member transactions
*Atrium::MembersApi* | [**list_members**](docs/MembersApi.md#list_members) | **GET** /users/{user_guid}/members | List members
*Atrium::MembersApi* | [**read_member**](docs/MembersApi.md#read_member) | **GET** /users/{user_guid}/members/{member_guid} | Read member
*Atrium::MembersApi* | [**read_member_status**](docs/MembersApi.md#read_member_status) | **GET** /users/{user_guid}/members/{member_guid}/status | Read member connection status
*Atrium::MembersApi* | [**resume_member**](docs/MembersApi.md#resume_member) | **PUT** /users/{user_guid}/members/{member_guid}/resume | Resume aggregation from MFA
*Atrium::MembersApi* | [**update_member**](docs/MembersApi.md#update_member) | **PUT** /users/{user_guid}/members/{member_guid} | Update member
*Atrium::MerchantsApi* | [**read_merchant**](docs/MerchantsApi.md#read_merchant) | **GET** /merchants/{merchant_guid} | Read merchant
*Atrium::TransactionsApi* | [**cleanse_and_categorize_transactions**](docs/TransactionsApi.md#cleanse_and_categorize_transactions) | **POST** /cleanse_and_categorize | Categorize transactions
*Atrium::TransactionsApi* | [**list_user_transactions**](docs/TransactionsApi.md#list_user_transactions) | **GET** /users/{user_guid}/transactions | List transactions for a user
*Atrium::TransactionsApi* | [**read_transaction**](docs/TransactionsApi.md#read_transaction) | **GET** /users/{user_guid}/transactions/{transaction_guid} | Read a transaction
*Atrium::UsersApi* | [**create_user**](docs/UsersApi.md#create_user) | **POST** /users | Create user
*Atrium::UsersApi* | [**delete_user**](docs/UsersApi.md#delete_user) | **DELETE** /users/{user_guid} | Delete user
*Atrium::UsersApi* | [**list_users**](docs/UsersApi.md#list_users) | **GET** /users | List users
*Atrium::UsersApi* | [**read_user**](docs/UsersApi.md#read_user) | **GET** /users/{user_guid} | Read user
*Atrium::UsersApi* | [**update_user**](docs/UsersApi.md#update_user) | **PUT** /users/{user_guid} | Update user
*Atrium::VerificationApi* | [**list_account_numbers**](docs/VerificationApi.md#list_account_numbers) | **GET** /users/{user_guid}/members/{member_guid}/account_numbers | Read account numbers
*Atrium::VerificationApi* | [**list_account_numbers_by_account**](docs/VerificationApi.md#list_account_numbers_by_account) | **GET** /users/{user_guid}/accounts/{account_guid}/account_numbers | Read account numbers by account GUID
*Atrium::VerificationApi* | [**verify_member**](docs/VerificationApi.md#verify_member) | **POST** /users/{user_guid}/members/{member_guid}/verify | Verify


## Documentation for Models

 - [Atrium::Account](docs/Account.md)
 - [Atrium::AccountNumber](docs/AccountNumber.md)
 - [Atrium::AccountNumbersResponseBody](docs/AccountNumbersResponseBody.md)
 - [Atrium::AccountOwner](docs/AccountOwner.md)
 - [Atrium::AccountOwnersResponseBody](docs/AccountOwnersResponseBody.md)
 - [Atrium::AccountResponseBody](docs/AccountResponseBody.md)
 - [Atrium::AccountsResponseBody](docs/AccountsResponseBody.md)
 - [Atrium::Challenge](docs/Challenge.md)
 - [Atrium::ChallengeOption](docs/ChallengeOption.md)
 - [Atrium::ChallengesResponseBody](docs/ChallengesResponseBody.md)
 - [Atrium::ConnectWidget](docs/ConnectWidget.md)
 - [Atrium::ConnectWidgetRequestBody](docs/ConnectWidgetRequestBody.md)
 - [Atrium::ConnectWidgetResponseBody](docs/ConnectWidgetResponseBody.md)
 - [Atrium::CredentialOption](docs/CredentialOption.md)
 - [Atrium::CredentialRequest](docs/CredentialRequest.md)
 - [Atrium::CredentialResponse](docs/CredentialResponse.md)
 - [Atrium::CredentialsResponseBody](docs/CredentialsResponseBody.md)
 - [Atrium::Holding](docs/Holding.md)
 - [Atrium::HoldingResponseBody](docs/HoldingResponseBody.md)
 - [Atrium::HoldingsResponseBody](docs/HoldingsResponseBody.md)
 - [Atrium::Institution](docs/Institution.md)
 - [Atrium::InstitutionResponseBody](docs/InstitutionResponseBody.md)
 - [Atrium::InstitutionsResponseBody](docs/InstitutionsResponseBody.md)
 - [Atrium::Member](docs/Member.md)
 - [Atrium::MemberConnectionStatus](docs/MemberConnectionStatus.md)
 - [Atrium::MemberConnectionStatusResponseBody](docs/MemberConnectionStatusResponseBody.md)
 - [Atrium::MemberCreateRequest](docs/MemberCreateRequest.md)
 - [Atrium::MemberCreateRequestBody](docs/MemberCreateRequestBody.md)
 - [Atrium::MemberResponseBody](docs/MemberResponseBody.md)
 - [Atrium::MemberResumeRequest](docs/MemberResumeRequest.md)
 - [Atrium::MemberResumeRequestBody](docs/MemberResumeRequestBody.md)
 - [Atrium::MemberUpdateRequest](docs/MemberUpdateRequest.md)
 - [Atrium::MemberUpdateRequestBody](docs/MemberUpdateRequestBody.md)
 - [Atrium::MembersResponseBody](docs/MembersResponseBody.md)
 - [Atrium::Merchant](docs/Merchant.md)
 - [Atrium::MerchantResponseBody](docs/MerchantResponseBody.md)
 - [Atrium::Pagination](docs/Pagination.md)
 - [Atrium::Transaction](docs/Transaction.md)
 - [Atrium::TransactionCleanseAndCategorizeRequest](docs/TransactionCleanseAndCategorizeRequest.md)
 - [Atrium::TransactionCleanseAndCategorizeResponse](docs/TransactionCleanseAndCategorizeResponse.md)
 - [Atrium::TransactionResponseBody](docs/TransactionResponseBody.md)
 - [Atrium::TransactionsCleanseAndCategorizeRequestBody](docs/TransactionsCleanseAndCategorizeRequestBody.md)
 - [Atrium::TransactionsCleanseAndCategorizeResponseBody](docs/TransactionsCleanseAndCategorizeResponseBody.md)
 - [Atrium::TransactionsResponseBody](docs/TransactionsResponseBody.md)
 - [Atrium::User](docs/User.md)
 - [Atrium::UserCreateRequestBody](docs/UserCreateRequestBody.md)
 - [Atrium::UserResponseBody](docs/UserResponseBody.md)
 - [Atrium::UserUpdateRequestBody](docs/UserUpdateRequestBody.md)
 - [Atrium::UsersResponseBody](docs/UsersResponseBody.md)

