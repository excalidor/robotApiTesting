*** Settings ***
Library  Collections
Library  String
Library  RequestsLibrary
Library  OperatingSystem
Suite Setup    Create Session  jsonplaceholder  https://jsonplaceholder.typicode.com
Suite Teardown  Delete All Sessions

*** Variables ***
${JSON_DATA}  '{"file":{"path":"/logo1.png"},"token":"some-valid-oauth-token"}'

*** Test Cases ***
Quick Get Request Test
    [Tags]  get
    ${response}=    GET  https://www.google.com

Quick Get Request With Parameters Test
    [Tags]  get
    ${response}=    GET  https://www.google.com/search  params=query=ciao  expected_status=200

Quick Get A JSON Body Test
    [Tags]  get
    ${response}=    GET  https://jsonplaceholder.typicode.com/posts/1
    Should Be Equal As Strings    1  ${response.json()}[id]

Delete Request With Data
    [Tags]  deleteTest
    Create Session   httpbin   http://httpbin.org
    ${headers}=  Create Dictionary  Content-Type=application/json
    ${resp}=   Delete Request   httpbin   /delete   data=${JSON_DATA}   headers=${headers}
    ${jsondata}=   To Json   ${resp.content}

Encoding Error
    [Tags]  errorTest
    Create Session   httpbin   http://httpbin.org
    ${headers}=  Create Dictionary  Content-Type=application/json
    Set Suite Variable  ${data}   { "elementToken":"token", "matchCriteria":[{"field":"name","dataType":"string","useOr":"false","fieldValue":"Operation check 07", "closeParen": "false", "openParen": "false", "operator": "equalTo"}], "account": { "annualRevenue": "456666", "name": "Account", "numberOfEmployees": "integer", "billingAddress": { "city": "Miami", "country": "US", "countyOrDistrict": "us or fl", "postalCode": "33131", "stateOrProvince": "florida", "street1": "Trade Center", "street2": "North Main rd" }, "number": "432", "industry": "Bank", "type": "string", "shippingAddress": { "city": "denver", "country": "us", "countyOrDistrict": "us or co", "postalCode": "80202", "stateOrProvince": "colorado", "street1": "Main street", "street2": "101 Avenu"}}}

    ${resp}=  Post Request  httpbin  /post  data=${data}  headers=${headers}
    Should Be Equal As Strings  ${resp.status_code}  200

Post Request With XML File
    [Tags]  post
    Create Session  httpbin  http://httpbin.org

    ${file_data}=  Get File  ${CURDIR}${/}test.xml
    ${files}=  Create Dictionary  xml=${file_data}
    ${headers}=  Create Dictionary  Authorization=testing-token
    Log  ${headers}
    ${resp}=  Post Request  httpbin  /post  files=${files}  headers=${headers}

    Log  ${resp.json()}

    Set Test Variable  ${req_headers}  ${resp.json()['headers']}
    Log  ${req_headers}
    Dictionary Should Contain Key  ${req_headers}  Authorization

Quick GET Request Status Only Test
    [Tags]  skip
    ${response}=    GET    https://www.google.com/search    params=query=ciao    expected_status=200

Quick GET A JSON Body
    [Tags]  get json
    ${response}=    GET    https://jsonplaceholder.typicode.com/posts/1
    Should Be Equal As Strings   1  ${response.json()}[id]

Get Request Test
    [Tags]  get
    Create Session    jsonplaceholder    https://jsonplaceholder.typicode.com
    Create Session    google             http://www.google.com

    ${resp_google}=   GET On Session     google             /           expected_status=200
    ${resp_json}=     GET On Session     jsonplaceholder    /posts/1

    Should Be Equal As Strings           ${resp_google.reason}    OK
    Dictionary Should Contain Value      ${resp_json.json()}    sunt aut facere repellat provident occaecati excepturi optio reprehenderit

Post Request Test
    [Tags]  post
    Create Session    jsonplaceholder    https://jsonplaceholder.typicode.com

    &{data}=          Create dictionary  title=Robotframework requests  body=This is a test!  userId=1
    ${resp}=          POST On Session    jsonplaceholder     /posts    json=${data}    expected_status=anything

    Status Should Be                     201    ${resp}
    Dictionary Should Contain Key        ${resp.json()}     id

Get Request Test2
    [Tags]  get
    Create Session    google  http://www.google.com
    ${resp_google}=   GET On Session  google  /  expected_status=200
    Should Be Equal As Strings          ${resp_google.reason}  OK

Post Request Test2
    [Tags]  post
    &{data}=    Create dictionary  title=Robotframework requests  body=This is a test!  userId=1
    ${resp}=    POST On Session    jsonplaceholder  /posts  json=${data}  expected_status=anything
    Status Should Be                 201  ${resp}