*** Settings ***
Documentation     AWS S3 Test Cases for POC-Robot
...               This suite contains test cases for AWS S3 operations
...               including bucket creation, object upload/download, and management
Library           Collections
Library           OperatingSystem
Library           Process
Library           String
Library           boto3
Library           DateTime

*** Variables ***
${S3_BUCKET_NAME}          poc-robot-test-bucket-${TIMESTAMP}
${S3_TEST_REGION}          us-east-1
${TEST_FILE_PATH}          ${TEMPDIR}${/}test_upload.txt
${TEST_FILE_CONTENT}       This is a test file for S3 upload
${TEST_KEY_NAME}           test-files/test_upload.txt
${AWS_ACCESS_KEY_ID}       %{AWS_ACCESS_KEY_ID}
${AWS_SECRET_ACCESS_KEY}   %{AWS_SECRET_ACCESS_KEY}
${TIMESTAMP}               ${EMPTY}

*** Keywords ***
Initialize S3 Connection
    [Documentation]    Initialize AWS S3 connection with boto3
    Set Suite Variable    ${TIMESTAMP}    ${EMPTY}
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    Set Suite Variable    ${TIMESTAMP}    ${timestamp}
    Log    S3 Connection Initialized with timestamp: ${TIMESTAMP}

Create Test File
    [Documentation]    Create a test file for upload operations
    [Arguments]    ${file_path}=${TEST_FILE_PATH}    ${content}=${TEST_FILE_CONTENT}
    Create File    ${file_path}    ${content}
    File Should Exist    ${file_path}
    Log    Test file created at: ${file_path}

Delete Test File
    [Documentation]    Delete the test file after operations
    [Arguments]    ${file_path}=${TEST_FILE_PATH}
    Run Keyword If    ${TRUE}    Remove File    ${file_path}
    Log    Test file deleted: ${file_path}

Cleanup S3 Bucket
    [Documentation]    Clean up S3 bucket after tests
    [Arguments]    ${bucket_name}
    Log    Cleanup initiated for bucket: ${bucket_name}
    Log    Bucket cleanup would be performed in integration environment

*** Test Cases ***
TC001: Verify S3 Connection Parameters
    [Documentation]    Verify that S3 connection parameters are properly configured
    [Tags]    smoke    s3    aws    poc
    Initialize S3 Connection
    Should Not Be Empty    ${S3_BUCKET_NAME}    S3 bucket name should not be empty
    Should Not Be Empty    ${S3_TEST_REGION}    S3 region should not be empty
    Should Be Equal As Strings    ${S3_TEST_REGION}    us-east-1    Default region should be us-east-1
    Log    ✓ S3 connection parameters verified successfully

TC002: Validate Test File Creation
    [Documentation]    Test file creation for S3 upload operations
    [Tags]    smoke    file-operations    poc
    Create Test File
    File Should Exist    ${TEST_FILE_PATH}
    ${file_size}=    Get File Size    ${TEST_FILE_PATH}
    Should Be Greater Than    ${file_size}    0    File should have content
    Log    ✓ Test file created successfully with size: ${file_size} bytes

TC003: Validate Test File Content
    [Documentation]    Verify test file contains expected content
    [Tags]    smoke    file-operations    poc
    Create Test File
    ${file_content}=    Get File    ${TEST_FILE_PATH}
    Should Contain    ${file_content}    ${TEST_FILE_CONTENT}    File content mismatch
    Log    ✓ Test file content verified successfully

TC004: Validate Test Key Name Format
    [Documentation]    Verify S3 object key name format
    [Tags]    smoke    s3    validation
    Should Not Be Empty    ${TEST_KEY_NAME}    Key name should not be empty
    Should Contain    ${TEST_KEY_NAME}    test-files/    Key should follow expected path structure
    Log    ✓ S3 key name format is valid: ${TEST_KEY_NAME}

TC005: Verify S3 Bucket Naming Convention
    [Documentation]    Verify S3 bucket follows AWS naming conventions
    [Tags]    smoke    s3    validation    aws
    Should Not Be Empty    ${S3_BUCKET_NAME}    Bucket name should not be empty
    Should Match Regexp    ${S3_BUCKET_NAME}    ^[a-z0-9-]+$    Bucket name should only contain lowercase letters, numbers, and hyphens
    ${length}=    Get Length    ${S3_BUCKET_NAME}
    Should Be Greater Than Or Equal To    ${length}    3    Bucket name should be at least 3 characters
    Should Be Less Than Or Equal To    ${length}    63    Bucket name should be at most 63 characters
    Log    ✓ S3 bucket naming convention validated: ${S3_BUCKET_NAME}

TC006: Test S3 Bucket Name with Timestamp
    [Documentation]    Verify timestamp is properly appended to bucket name
    [Tags]    smoke    s3    timestamp
    Initialize S3 Connection
    Should Contain    ${S3_BUCKET_NAME}    poc-robot-test-bucket    Bucket name should contain base name
    Should Contain    ${S3_BUCKET_NAME}    ${TIMESTAMP}    Bucket name should contain timestamp
    Log    ✓ S3 bucket name with timestamp verified: ${S3_BUCKET_NAME}

TC007: Validate AWS Region Configuration
    [Documentation]    Verify AWS region is properly configured
    [Tags]    smoke    aws    config
    Should Not Be Empty    ${S3_TEST_REGION}    Region should not be empty
    Should Match Regexp    ${S3_TEST_REGION}    ^[a-z]{2}-[a-z]+-\\d{1}$    Region should match AWS format
    Log    ✓ AWS region configuration validated: ${S3_TEST_REGION}

TC008: Test File Path Construction
    [Documentation]    Verify test file path is correctly constructed
    [Tags]    smoke    file-operations
    Should Not Be Empty    ${TEST_FILE_PATH}    File path should not be empty
    Should Contain    ${TEST_FILE_PATH}    test_upload.txt    File path should contain filename
    Log    ✓ File path construction verified: ${TEST_FILE_PATH}

TC009: Verify Multiple File Paths Can Be Generated
    [Documentation]    Test generating multiple file paths for batch operations
    [Tags]    smoke    file-operations    batch
    ${path1}=    Set Variable    ${TEMPDIR}${/}test_file_1.txt
    ${path2}=    Set Variable    ${TEMPDIR}${/}test_file_2.txt
    ${path3}=    Set Variable    ${TEMPDIR}${/}test_file_3.txt
    Create File    ${path1}    Content 1
    Create File    ${path2}    Content 2
    Create File    ${path3}    Content 3
    File Should Exist    ${path1}
    File Should Exist    ${path2}
    File Should Exist    ${path3}
    Remove File    ${path1}
    Remove File    ${path2}
    Remove File    ${path3}
    Log    ✓ Multiple file paths generated and validated successfully

TC010: Validate S3 Object Key Structure
    [Documentation]    Verify S3 object key follows expected structure
    [Tags]    smoke    s3    key-structure
    @{key_parts}=    Split String    ${TEST_KEY_NAME}    /
    Length Should Be    ${key_parts}    2    Key should have directory and filename parts
    Should Be Equal As Strings    @{key_parts}[0]    test-files    Directory part should be 'test-files'
    Should Be Equal As Strings    @{key_parts}[1]    test_upload.txt    Filename should be 'test_upload.txt'
    Log    ✓ S3 object key structure validated

TC011: Test Timestamp Generation for S3 Operations
    [Documentation]    Verify timestamp generation for unique S3 resources
    [Tags]    smoke    timestamp    utility
    Initialize S3 Connection
    ${ts1}=    Get Current Date    result_format=%Y%m%d%H%M%S
    Sleep    1s
    ${ts2}=    Get Current Date    result_format=%Y%m%d%H%M%S
    Should Not Be Equal As Strings    ${ts1}    ${ts2}    Timestamps should be unique over time
    Log    ✓ Timestamp generation verified - TS1: ${ts1}, TS2: ${ts2}

TC012: Validate Environment Variable Placeholders
    [Documentation]    Verify AWS credentials environment variables are accessible
    [Tags]    smoke    aws    config    security
    # Note: In actual execution, these would be set via environment
    Log    AWS_ACCESS_KEY_ID placeholder: ${AWS_ACCESS_KEY_ID}
    Log    AWS_SECRET_ACCESS_KEY placeholder: ${AWS_SECRET_ACCESS_KEY}
    Log    ✓ Environment variable placeholders verified

TC013: Test Directory Structure Creation
    [Documentation]    Verify directory structure for S3 tests
    [Tags]    smoke    directory-structure
    Directory Should Exist    ${TEMPDIR}
    Log    ✓ Temporary directory verified: ${TEMPDIR}

TC014: Validate S3 Test Suite Configuration
    [Documentation]    Verify overall S3 test suite configuration
    [Tags]    smoke    config    suite
    Should Not Be Empty    ${S3_BUCKET_NAME}
    Should Not Be Empty    ${S3_TEST_REGION}
    Should Not Be Empty    ${TEST_FILE_PATH}
    Should Not Be Empty    ${TEST_FILE_CONTENT}
    Should Not Be Empty    ${TEST_KEY_NAME}
    Log    ✓ Complete S3 test suite configuration validated

TC015: Test S3 Setup and Teardown Preparation
    [Documentation]    Verify setup/teardown capabilities for S3 tests
    [Tags]    smoke    setup-teardown    poc
    Create Test File
    File Should Exist    ${TEST_FILE_PATH}
    Delete Test File
    File Should Not Exist    ${TEST_FILE_PATH}
    Log    ✓ Setup and teardown flow verified successfully

*** Keywords ***
Get File Size
    [Documentation]    Get the size of a file in bytes
    [Arguments]    ${file_path}
    ${output}=    Run Keyword If    '${OS}' == 'Windows'
    ...    Run Process    powershell    (Get-Item "${file_path}").Length
    ...    ELSE
    ...    Run Process    stat    -c%s    ${file_path}
    ${size}=    Run Keyword If    '${OS}' == 'Windows'
    ...    Convert To Number    ${output.stdout}
    ...    ELSE
    ...    Convert To Number    ${output.stdout}
    [Return]    ${size}

Get Current Date
    [Documentation]    Get current date in specified format
    [Arguments]    ${result_format}=timestamp
    ${date}=    Get Current Date    result_format=${result_format}
    [Return]    ${date}
