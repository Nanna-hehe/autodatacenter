*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}    https://jsonplaceholder.typicode.com
${ENDPOINT}    /posts/1

*** Test Cases ***
Example API Test Case
    Create Session    jsonplaceholder    ${BASE_URL}
    ${response}=    GET On Session    jsonplaceholder    ${ENDPOINT}
    Status Should Be    200    ${response}
    
    # Verify response content
    ${json}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${json}    title
    Dictionary Should Contain Value    ${json}    sunt aut facere repellat provident occaecati excepturi optio reprehenderit
    
    # Post a new resource
    &{data}=    Create Dictionary    title=foo    body=bar    userId=1
    ${post_response}=    POST On Session    jsonplaceholder    /posts    json=${data}
    Status Should Be    201    ${post_response}
    
    # Verify the posted data
    ${post_json}=    Set Variable    ${post_response.json()}
    Dictionary Should Contain Key    ${post_json}    id
    Dictionary Should Contain Value    ${post_json}    foo

*** Keywords ***
Custom API Keyword
    [Arguments]    ${endpoint}
    ${response}=    GET On Session    jsonplaceholder    ${endpoint}
    RETURN    ${response}