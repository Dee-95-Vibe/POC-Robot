*** Settings ***
Documentation     Database testing test suite initialization
...               This module initializes the database test suite with common settings,
...               variables, and keywords for database testing operations.
Library           Collections
Library           DatabaseLibrary
Library           BuiltIn


*** Variables ***
${DATABASE_HOST}          localhost
${DATABASE_PORT}          5432
${DATABASE_NAME}          test_database
${DATABASE_USER}          test_user
${DATABASE_PASSWORD}      test_password
${DATABASE_DIALECT}       postgresql


*** Keywords ***
Initialize Database Test Suite
    [Documentation]    Initialize the database test suite with required configurations
    Log    Database Test Suite Initialization Started    INFO
    Log    Database Host: ${DATABASE_HOST}    DEBUG
    Log    Database Name: ${DATABASE_NAME}    DEBUG


Cleanup Database Test Suite
    [Documentation]    Cleanup resources after database tests
    Log    Database Test Suite Cleanup Completed    INFO
