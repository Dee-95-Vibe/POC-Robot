*** Settings ***
Documentation     Web automation test suite initialization
...               This file initializes the web testing environment for Robot Framework tests.
...               It sets up common variables, libraries, and configuration needed for web automation.

Library           Collections
Library           String
Library           DateTime

*** Variables ***
${TEST_ENVIRONMENT}    web
${BASE_URL}           http://localhost
${TIMEOUT}            10s
${IMPLICIT_WAIT}      5s

*** Keywords ***
Initialize Web Test Suite
    [Documentation]    Initialize the web test suite with default settings
    Log    Web test suite initialized    INFO
    Set Suite Variable    ${WEB_SUITE_INITIALIZED}    ${True}

Teardown Web Test Suite
    [Documentation]    Clean up web test suite resources
    Log    Web test suite teardown completed    INFO
