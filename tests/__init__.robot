*** Settings ***
Suite Setup       Suite Setup
Suite Teardown    Suite Teardown


*** Keywords ***
Suite Setup
    Log    Test Suite Setup Started
    Log    Current Date and Time: 2025-12-26 06:47:56 UTC

Suite Teardown
    Log    Test Suite Teardown Started
    Log    Cleaning up resources
