*** Settings ***
Documentation     Sample API Testing Suite
Library           RequestsLibrary
Library           Collections
Library           String

Suite Setup       Create Session    api_session    http://api.example.com
Suite Teardown    Delete All Sessions

*** Variables ***
${BASE_URL}       http://api.example.com
${API_TIMEOUT}    5

*** Test Cases ***
Test GET Request - Retrieve User Data
    [Documentation]    Test to retrieve user data using GET request
    [Tags]    api    get    users
    ${response}    GET On Session    api_session    /users/1
    Should Be Equal As Integers    ${response.status_code}    200
    ${json}    Convert To Dictionary    ${response.json()}
    Should Contain    ${json}    id
    Should Contain    ${json}    name

Test POST Request - Create New User
    [Documentation]    Test to create a new user using POST request
    [Tags]    api    post    users
    ${payload}    Create Dictionary    name=John Doe    email=john@example.com    phone=1234567890
    ${headers}    Create Dictionary    Content-Type=application/json
    ${response}    POST On Session    api_session    /users    json=${payload}    headers=${headers}
    Should Be Equal As Integers    ${response.status_code}    201
    ${json}    Convert To Dictionary    ${response.json()}
    Should Be Equal    ${json}[name]    John Doe
    Should Be Equal    ${json}[email]    john@example.com

Test PUT Request - Update User Data
    [Documentation]    Test to update user data using PUT request
    [Tags]    api    put    users
    ${user_id}    Set Variable    1
    ${payload}    Create Dictionary    name=Jane Doe    email=jane@example.com
    ${headers}    Create Dictionary    Content-Type=application/json
    ${response}    PUT On Session    api_session    /users/${user_id}    json=${payload}    headers=${headers}
    Should Be Equal As Integers    ${response.status_code}    200
    ${json}    Convert To Dictionary    ${response.json()}
    Should Be Equal    ${json}[name]    Jane Doe

Test DELETE Request - Remove User
    [Documentation]    Test to delete a user using DELETE request
    [Tags]    api    delete    users
    ${user_id}    Set Variable    1
    ${response}    DELETE On Session    api_session    /users/${user_id}
    Should Be Equal As Integers    ${response.status_code}    204

Test API Response Headers Validation
    [Documentation]    Test to validate response headers
    [Tags]    api    headers
    ${response}    GET On Session    api_session    /users/1
    Should Be Equal As Integers    ${response.status_code}    200
    Should Contain    ${response.headers}    Content-Type
    Should Be Equal    ${response.headers}[Content-Type]    application/json

Test API Endpoint with Query Parameters
    [Documentation]    Test API endpoint with query parameters
    [Tags]    api    get    parameters
    ${params}    Create Dictionary    page=1    limit=10
    ${response}    GET On Session    api_session    /users    params=${params}
    Should Be Equal As Integers    ${response.status_code}    200
    ${json}    Convert To Dictionary    ${response.json()}
    Should Contain    ${json}    data

Test API Response Timeout
    [Documentation]    Test API request with timeout
    [Tags]    api    timeout
    ${response}    GET On Session    api_session    /users/1    timeout=${API_TIMEOUT}
    Should Be Equal As Integers    ${response.status_code}    200

Test API Error Handling - 404 Not Found
    [Documentation]    Test API error handling for non-existent resource
    [Tags]    api    error     404
    ${response}    GET On Session    api_session    /users/9999    expected_status=404
    Should Be Equal As Integers    ${response.status_code}    404

Test API Error Handling - 400 Bad Request
    [Documentation]    Test API error handling for bad request
    [Tags]    api    error    400
    ${payload}    Create Dictionary    name=${EMPTY}
    ${headers}    Create Dictionary    Content-Type=application/json
    ${response}    POST On Session    api_session    /users    json=${payload}    headers=${headers}    expected_status=400
    Should Be Equal As Integers    ${response.status_code}    400

Test API Authentication with Bearer Token
    [Documentation]    Test API request with Bearer token authentication
    [Tags]    api    auth    bearer
    ${token}    Set Variable    eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9
    ${headers}    Create Dictionary    Authorization=Bearer ${token}    Content-Type=application/json
    ${response}    GET On Session    api_session    /users/1    headers=${headers}
    Should Be Equal As Integers    ${response.status_code}    200

*** Keywords ***
Convert To Dictionary
    [Documentation]    Convert JSON response to dictionary for assertion
    [Arguments]    ${json_object}
    [Return]    ${json_object}
