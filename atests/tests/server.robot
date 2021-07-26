*** Settings ***
Library   RequestsLibrary
Resource  ../res_setup.robot

Suite Setup     Setup Flask Http Server
Suite Teardown  Teardown Flask Http Server And Sessions

*** Test Cases ***
Post Content application/json With Empty Data Should Have No Body
    ${content-type}=  Create Dictionary  content-type  application/json
    ${resp}=  Post Request  ${GLOBAL_SESSION}  /anything  data=${EMPTY}  headers=${content-type}
    Should Be Empty  ${resp.json()['data']}

Post Content With Empty Data Should Have No Body
    ${resp}=  Post Request  ${GLOBAL_SESSION}  /anything  data=${EMPTY}
    Should Be Empty  ${resp.json()['data']}

Test NTLM Session without installed library
    ${auth}=    Create List  1  2  3
    Run Keyword And Expect Error  requests_ntlm module not installed  Create Ntlm Session  ntlm  http://localhost:80  ${auth}

Test On Session Keyword With Verify As Parameter

    ${resp}=  GET On Session  ${GLOBAL_SESSION}  /  verify=${False}
    Status Should Be  OK  ${resp}

Test On Session Keyword With None Cookies As Parameter

    ${resp}=  GET On Session  ${GLOBAL_SESSION}  /  cookies=${None}
    Status Should Be  OK  ${resp}

Test On Session Keyword With Cookies As Parameter

    ${resp}=  GET On Session  ${GLOBAL_SESSION}  /  cookies=${False}
    Status Should Be  OK  ${resp}

Test GET with list of values as params
    ${values_list}=     Create List    1    2    3    4    5
    ${parameters}=      Create Dictionary  key  ${values_list}
    ${resp}=            GET On Session  ${GLOBAL_SESSION}  url=/anything  params=${parameters}
    Should Contain      ${resp.json()}[url]  ?key=1&key=2&key=3&key=4&key=5
    Should Be Equal     ${resp.json()}[args]  ${parameters}

Test GET with spaces in dictionary as params
    ${parameters}=      Create Dictionary  key  v a l u e
    ${resp}=            GET On Session  ${GLOBAL_SESSION}  url=/anything  params=${parameters}
    Should Be Equal     ${resp.json()}[args]  ${parameters}

Test GET with spaces in string as params
    ${parameters}=      Create Dictionary
    ${resp}=            GET On Session  ${GLOBAL_SESSION}  url=/anything  params=key=v a l u e
    Should Contain      ${resp.json()}[url]  v%20a%20l%20u%20e
