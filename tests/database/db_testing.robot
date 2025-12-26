*** Settings ***
Documentation     Database Testing Suite - Sample test cases for database operations
Library           DatabaseLibrary
Library           OperatingSystem
Library           Collections

Suite Setup       Connect To Database
Suite Teardown    Disconnect From Database


*** Variables ***
${DB_HOST}        localhost
${DB_PORT}        5432
${DB_USER}        test_user
${DB_PASSWORD}    test_password
${DB_NAME}        test_database
${DB_MODULE}      psycopg2


*** Keywords ***
Connect To Database
    [Documentation]    Establish connection to the test database
    Connect To Database    ${DB_MODULE}    ${DB_NAME}    ${DB_USER}    ${DB_PASSWORD}    ${DB_HOST}    ${DB_PORT}

Disconnect From Database
    [Documentation]    Close database connection
    Disconnect From Database

Create Test Table
    [Documentation]    Create a sample test table
    Execute Sql String    CREATE TABLE IF NOT EXISTS users (id SERIAL PRIMARY KEY, username VARCHAR(100) NOT NULL, email VARCHAR(100) NOT NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)

Drop Test Table
    [Documentation]    Drop the test table
    Execute Sql String    DROP TABLE IF EXISTS users

Insert Test User
    [Arguments]    ${username}    ${email}
    [Documentation]    Insert a test user into the database
    Execute Sql String    INSERT INTO users (username, email) VALUES ('${username}', '${email}')

Delete All Test Users
    [Documentation]    Delete all test users from the database
    Execute Sql String    DELETE FROM users


*** Test Cases ***
Test Database Connection
    [Documentation]    Verify database connection is established
    Database Connection Is Open

Test Create Table
    [Documentation]    Create test table for database operations
    Create Test Table
    Table Must Exist    users

Test Insert Single Record
    [Documentation]    Test inserting a single record into the database
    Create Test Table
    Insert Test User    john_doe    john@example.com
    Table Must Have    users    1 rows

Test Insert Multiple Records
    [Documentation]    Test inserting multiple records into the database
    Create Test Table
    Insert Test User    alice    alice@example.com
    Insert Test User    bob    bob@example.com
    Insert Test User    charlie    charlie@example.com
    Table Must Have    users    3 rows

Test Query Records
    [Documentation]    Test querying records from the database
    Create Test Table
    Insert Test User    test_user    test@example.com
    ${result}    Query    SELECT * FROM users WHERE username='test_user'
    Should Be Equal As Strings    ${result[0][1]}    test_user

Test Query By Email
    [Documentation]    Test querying records by email address
    Create Test Table
    Insert Test User    email_test    unique@example.com
    ${result}    Query    SELECT email FROM users WHERE email='unique@example.com'
    Should Be Equal As Strings    ${result[0][0]}    unique@example.com

Test Update Record
    [Documentation]    Test updating a record in the database
    Create Test Table
    Insert Test User    update_test    old@example.com
    Execute Sql String    UPDATE users SET email='new@example.com' WHERE username='update_test'
    ${result}    Query    SELECT email FROM users WHERE username='update_test'
    Should Be Equal As Strings    ${result[0][0]}    new@example.com

Test Delete Record
    [Documentation]    Test deleting a record from the database
    Create Test Table
    Insert Test User    delete_test    delete@example.com
    Table Must Have    users    1 rows
    Execute Sql String    DELETE FROM users WHERE username='delete_test'
    Table Must Have    users    0 rows

Test Record Count
    [Documentation]    Test counting records in the database
    Create Test Table
    Insert Test User    user1    user1@example.com
    Insert Test User    user2    user2@example.com
    Insert Test User    user3    user3@example.com
    ${count}    Query    SELECT COUNT(*) FROM users
    Should Be Equal As Numbers    ${count[0][0]}    3

Test Database Cleanup
    [Documentation]    Clean up test data after test execution
    Create Test Table
    Insert Test User    cleanup1    cleanup1@example.com
    Insert Test User    cleanup2    cleanup2@example.com
    Delete All Test Users
    Table Must Have    users    0 rows
    Drop Test Table
    Table Must Not Exist    users

Test Constraint Validation
    [Documentation]    Test database constraints are enforced
    Create Test Table
    Insert Test User    constraint_test    constraint@example.com
    [Teardown]    Drop Test Table

Test Data Integrity
    [Documentation]    Verify data integrity after insert operations
    Create Test Table
    Insert Test User    integrity_check    integrity@example.com
    ${result}    Query    SELECT COUNT(*) FROM users
    Should Be Equal As Numbers    ${result[0][0]}    1
    [Teardown]    Drop Test Table

Test Timestamp Functionality
    [Documentation]    Verify timestamp is automatically set on record creation
    Create Test Table
    Insert Test User    timestamp_test    timestamp@example.com
    ${result}    Query    SELECT created_at FROM users WHERE username='timestamp_test'
    Should Not Be Equal    ${result[0][0]}    ${None}
    [Teardown]    Drop Test Table
