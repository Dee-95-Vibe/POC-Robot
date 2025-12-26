*** Settings ***
Documentation     Web Automation Test Suite
...               This suite contains sample test cases for web automation using Robot Framework

Library           SeleniumLibrary
Library           Collections
Library           String

*** Variables ***
${BROWSER}                    chrome
${GOOGLE_URL}                 https://www.google.com
${WIKIPEDIA_URL}              https://www.wikipedia.org
${TIMEOUT}                    10s
${IMPLICIT_WAIT}              5s

*** Test Cases ***
Test Case 1: Open Google And Search
    [Documentation]    Test to open Google and perform a search
    [Tags]    web    google    smoke
    Open Browser    ${GOOGLE_URL}    ${BROWSER}
    Set Implicit Wait    ${IMPLICIT_WAIT}
    Wait Until Page Contains    Google Search    ${TIMEOUT}
    Input Text    name:q    Robot Framework
    Press Keys    name:q    Return
    Sleep    2s
    Page Should Contain    Robot Framework
    [Teardown]    Close Browser

Test Case 2: Verify Wikipedia Page Title
    [Documentation]    Test to verify Wikipedia page title and content
    [Tags]    web    wikipedia    smoke
    Open Browser    ${WIKIPEDIA_URL}    ${BROWSER}
    Set Implicit Wait    ${IMPLICIT_WAIT}
    Title Should Be    Wikipedia
    Page Should Contain    The Free Encyclopedia
    [Teardown]    Close Browser

Test Case 3: Verify Multiple Elements On Page
    [Documentation]    Test to verify multiple elements exist on a web page
    [Tags]    web    elements    sanity
    Open Browser    ${GOOGLE_URL}    ${BROWSER}
    Set Implicit Wait    ${IMPLICIT_WAIT}
    Page Should Contain Element    name:q
    Element Should Be Visible    name:q
    Page Should Contain Button    Google Search
    [Teardown]    Close Browser

Test Case 4: Navigate Between Pages
    [Documentation]    Test to navigate between different URLs
    [Tags]    web    navigation    sanity
    Open Browser    ${GOOGLE_URL}    ${BROWSER}
    Set Implicit Wait    ${IMPLICIT_WAIT}
    Wait Until Page Contains    Google Search    ${TIMEOUT}
    Go To    ${WIKIPEDIA_URL}
    Wait Until Page Contains    The Free Encyclopedia    ${TIMEOUT}
    Page Should Contain    Wikipedia
    Go Back
    Wait Until Page Contains    Google Search    ${TIMEOUT}
    [Teardown]    Close Browser

Test Case 5: Test Form Input And Validation
    [Documentation]    Test form input with validation
    [Tags]    web    form    sanity
    Open Browser    ${GOOGLE_URL}    ${BROWSER}
    Set Implicit Wait    ${IMPLICIT_WAIT}
    Input Text    name:q    SeleniumLibrary
    ${input_value}=    Get Value    name:q
    Should Be Equal    ${input_value}    SeleniumLibrary
    Clear Element Text    name:q
    ${cleared_value}=    Get Value    name:q
    Should Be Equal    ${cleared_value}    ${EMPTY}
    [Teardown]    Close Browser

Test Case 6: Test Page Load And Wait
    [Documentation]    Test page load with explicit wait conditions
    [Tags]    web    wait    sanity
    Open Browser    ${GOOGLE_URL}    ${BROWSER}
    Set Implicit Wait    ${IMPLICIT_WAIT}
    Wait Until Page Contains    Google Search    ${TIMEOUT}
    Wait Until Element Is Visible    name:q    ${TIMEOUT}
    Element Should Be Visible    name:q
    [Teardown]    Close Browser

*** Keywords ***
Custom Setup
    [Documentation]    Custom setup keyword for test execution
    Open Browser    ${GOOGLE_URL}    ${BROWSER}
    Set Implicit Wait    ${IMPLICIT_WAIT}

Custom Teardown
    [Documentation]    Custom teardown keyword for test execution
    Close Browser

Verify Page Title Contains
    [Documentation]    Verify that page title contains expected text
    [Arguments]    ${expected_text}
    ${title}=    Get Title
    Should Contain    ${title}    ${expected_text}

Navigate And Verify
    [Documentation]    Navigate to URL and verify page contains text
    [Arguments]    ${url}    ${expected_text}
    Go To    ${url}
    Wait Until Page Contains    ${expected_text}    ${TIMEOUT}
