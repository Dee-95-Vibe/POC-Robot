# POC-Robot

A comprehensive automation testing framework for web applications, APIs, databases, and AWS S3 services.

## Table of Contents
- [Project Overview](#project-overview)
- [Project Structure](#project-structure)
- [Setup Instructions](#setup-instructions)
- [Module Descriptions](#module-descriptions)
  - [Web Automation](#web-automation)
  - [API Testing](#api-testing)
  - [Database Testing](#database-testing)
  - [AWS S3 Testing](#aws-s3-testing)
- [Configuration](#configuration)
- [Running Tests](#running-tests)
- [Contributing](#contributing)
- [License](#license)

## Project Overview

POC-Robot is a proof-of-concept automation testing framework built with Python and Selenium, designed to provide comprehensive testing capabilities across multiple platforms and services:

- **Web Automation**: Automated UI testing using Selenium WebDriver
- **API Testing**: RESTful API endpoint testing and validation
- **Database Testing**: Direct database query execution and data validation
- **AWS S3 Testing**: S3 bucket operations and file management testing

## Project Structure

```
POC-Robot/
├── README.md                           # This file
├── requirements.txt                    # Python dependencies
├── setup.py                            # Package setup configuration
├── config/                             # Configuration files
│   ├── __init__.py
│   ├── config.yaml                     # Main configuration file
│   ├── environments.yaml               # Environment-specific settings
│   └── test_data.yaml                  # Test data definitions
├── src/                                # Source code directory
│   ├── __init__.py
│   ├── web_automation/                 # Web automation module
│   │   ├── __init__.py
│   │   ├── driver_factory.py           # WebDriver initialization
│   │   ├── page_objects/               # Page Object Models
│   │   │   ├── __init__.py
│   │   │   ├── base_page.py            # Base page class
│   │   │   ├── login_page.py
│   │   │   ├── home_page.py
│   │   │   └── dashboard_page.py
│   │   ├── locators/                   # Element locators
│   │   │   ├── __init__.py
│   │   │   ├── base_locators.py
│   │   │   ├── login_locators.py
│   │   │   └── dashboard_locators.py
│   │   └── utilities/                  # Web utilities
│   │       ├── __init__.py
│   │       ├── element_handler.py      # Element interaction methods
│   │       ├── wait_helper.py          # Wait conditions and helpers
│   │       └── screenshot_handler.py   # Screenshot capture utilities
│   ├── api_testing/                    # API testing module
│   │   ├── __init__.py
│   │   ├── client.py                   # HTTP client wrapper
│   │   ├── endpoints/                  # API endpoint definitions
│   │   │   ├── __init__.py
│   │   │   ├── base_endpoint.py
│   │   │   ├── user_endpoint.py
│   │   │   ├── product_endpoint.py
│   │   │   └── order_endpoint.py
│   │   ├── validators/                 # Response validators
│   │   │   ├── __init__.py
│   │   │   ├── response_validator.py
│   │   │   ├── schema_validator.py
│   │   │   └── status_validator.py
│   │   └── utilities/                  # API utilities
│   │       ├── __init__.py
│   │       ├── request_builder.py      # Request construction helpers
│   │       ├── response_parser.py      # Response parsing utilities
│   │       └── auth_handler.py         # Authentication handling
│   ├── database_testing/               # Database testing module
│   │   ├── __init__.py
│   │   ├── db_connection.py            # Database connection manager
│   │   ├── query_executor.py           # SQL query execution
│   │   ├── db_validators/              # Data validation
│   │   │   ├── __init__.py
│   │   │   ├── base_validator.py
│   │   │   ├── data_validator.py
│   │   │   └── integrity_validator.py
│   │   └── utilities/                  # Database utilities
│   │       ├── __init__.py
│   │       ├── connection_pool.py      # Connection pooling
│   │       ├── query_builder.py        # Query building utilities
│   │       └── data_handler.py         # Data manipulation helpers
│   ├── aws_s3/                         # AWS S3 testing module
│   │   ├── __init__.py
│   │   ├── s3_client.py                # S3 client wrapper
│   │   ├── s3_operations.py            # S3 operations (upload, download, etc.)
│   │   ├── validators/                 # S3 validators
│   │   │   ├── __init__.py
│   │   │   ├── bucket_validator.py
│   │   │   ├── file_validator.py
│   │   │   └── permission_validator.py
│   │   └── utilities/                  # S3 utilities
│   │       ├── __init__.py
│   │       ├── file_handler.py         # Local file operations
│   │       ├── bucket_manager.py       # Bucket management
│   │       └── metadata_handler.py     # Object metadata handling
│   └── common/                         # Shared utilities
│       ├── __init__.py
│       ├── logger.py                   # Logging configuration
│       ├── config_loader.py            # Configuration loading utilities
│       ├── constants.py                # Application constants
│       ├── exceptions.py               # Custom exceptions
│       └── helpers.py                  # General helper functions
├── tests/                              # Test suite directory
│   ├── __init__.py
│   ├── conftest.py                     # Pytest configuration and fixtures
│   ├── web_automation_tests/           # Web automation test cases
│   │   ├── __init__.py
│   │   ├── test_login.py
│   │   ├── test_dashboard.py
│   │   └── test_user_workflows.py
│   ├── api_tests/                      # API test cases
│   │   ├── __init__.py
│   │   ├── test_user_endpoints.py
│   │   ├── test_product_endpoints.py
│   │   └── test_order_endpoints.py
│   ├── database_tests/                 # Database test cases
│   │   ├── __init__.py
│   │   ├── test_data_integrity.py
│   │   ├── test_user_data.py
│   │   └── test_transactions.py
│   ├── aws_s3_tests/                   # AWS S3 test cases
│   │   ├── __init__.py
│   │   ├── test_bucket_operations.py
│   │   ├── test_file_upload_download.py
│   │   └── test_permissions.py
│   └── fixtures/                       # Test fixtures and data
│       ├── __init__.py
│       ├── test_data.json
│       ├── mock_responses.json
│       └── sample_files/
├── docs/                               # Documentation
│   ├── INSTALLATION.md
│   ├── API_TESTING_GUIDE.md
│   ├── WEB_AUTOMATION_GUIDE.md
│   ├── DATABASE_GUIDE.md
│   └── AWS_S3_GUIDE.md
├── logs/                               # Test execution logs
│   └── .gitkeep
├── reports/                            # Test reports directory
│   └── .gitkeep
└── .gitignore                          # Git ignore file
```

## Setup Instructions

### Prerequisites

- Python 3.8 or higher
- pip (Python package manager)
- Git
- Chrome/Firefox browser (for web automation)
- Database credentials (for database testing)
- AWS credentials (for S3 testing)

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/Dee-95-Vibe/POC-Robot.git
   cd POC-Robot
   ```

2. **Create a virtual environment**
   ```bash
   python -m venv venv
   
   # Activate virtual environment
   # On Windows:
   venv\Scripts\activate
   # On macOS/Linux:
   source venv/bin/activate
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Configure environment variables**
   ```bash
   # Create .env file in project root
   cp .env.example .env
   
   # Edit .env with your credentials
   # Database credentials
   DB_HOST=your_db_host
   DB_PORT=5432
   DB_USER=your_db_user
   DB_PASSWORD=your_db_password
   DB_NAME=your_db_name
   
   # AWS credentials
   AWS_ACCESS_KEY_ID=your_access_key
   AWS_SECRET_ACCESS_KEY=your_secret_key
   AWS_REGION=us-east-1
   
   # Application URLs
   BASE_URL=https://your-application.com
   API_BASE_URL=https://api.your-application.com
   ```

5. **Download WebDriver** (if not automated)
   ```bash
   # For Chrome
   # Download from: https://chromedriver.chromium.org/
   # Place in drivers/ directory
   ```

6. **Verify installation**
   ```bash
   pytest --version
   python -c "from selenium import webdriver; print('Selenium OK')"
   ```

## Module Descriptions

### Web Automation

The web automation module provides comprehensive UI testing capabilities using Selenium WebDriver.

**Key Components:**

- **driver_factory.py**: Initializes and manages WebDriver instances
  - Supports Chrome, Firefox, Edge browsers
  - Handles headless and headful modes
  - Configures timeouts and capabilities

- **Page Objects**: Implements Page Object Model pattern
  - `base_page.py`: Base class with common methods
  - Individual page classes for different application pages
  - Encapsulates element locators and interactions

- **Locators**: Centralized element locator definitions
  - Uses By strategy (ID, CSS, XPath)
  - Organized by page/component
  - Easy maintenance and updates

- **Utilities**:
  - `element_handler.py`: Click, send_keys, get_text operations
  - `wait_helper.py`: Explicit waits, custom conditions
  - `screenshot_handler.py`: Screenshot capture for debugging

**Example Usage:**
```python
from src.web_automation.page_objects.login_page import LoginPage
from src.web_automation.driver_factory import DriverFactory

driver = DriverFactory.create_driver("chrome")
login_page = LoginPage(driver)
login_page.login("username", "password")
```

### API Testing

The API testing module provides RESTful API endpoint testing and validation.

**Key Components:**

- **client.py**: HTTP client wrapper
  - Handles GET, POST, PUT, DELETE, PATCH requests
  - Request/response logging
  - Error handling and retries

- **Endpoints**: API endpoint definitions
  - `base_endpoint.py`: Base class with common methods
  - Endpoint-specific classes (users, products, orders, etc.)
  - URL construction and parameter handling

- **Validators**: Response validation
  - `response_validator.py`: Status code, headers, body validation
  - `schema_validator.py`: JSON schema validation
  - `status_validator.py`: HTTP status code checks

- **Utilities**:
  - `request_builder.py`: Build complex requests with parameters
  - `response_parser.py`: Parse and extract response data
  - `auth_handler.py`: Bearer tokens, API keys, Basic auth

**Example Usage:**
```python
from src.api_testing.endpoints.user_endpoint import UserEndpoint
from src.api_testing.validators.response_validator import ResponseValidator

endpoint = UserEndpoint(base_url="https://api.example.com")
response = endpoint.get_user(user_id=123)
validator = ResponseValidator(response)
assert validator.is_status_ok()
assert validator.validate_schema(user_schema)
```

### Database Testing

The database testing module enables direct database query execution and data validation.

**Key Components:**

- **db_connection.py**: Database connection manager
  - Supports PostgreSQL, MySQL, SQL Server, Oracle
  - Connection pooling for performance
  - SSL/TLS configuration

- **query_executor.py**: SQL query execution
  - Execute SELECT, INSERT, UPDATE, DELETE queries
  - Transaction management
  - Prepared statements for security

- **Validators**: Data validation
  - `data_validator.py`: Data type, value, and format validation
  - `integrity_validator.py`: Foreign keys, constraints, relationships

- **Utilities**:
  - `connection_pool.py`: Manage connection pools
  - `query_builder.py`: Build dynamic SQL queries
  - `data_handler.py`: Data transformation and comparison

**Example Usage:**
```python
from src.database_testing.db_connection import DatabaseConnection
from src.database_testing.query_executor import QueryExecutor

conn = DatabaseConnection(host="localhost", database="test_db")
executor = QueryExecutor(conn)
result = executor.execute("SELECT * FROM users WHERE id = %s", (123,))
assert result[0]['name'] == "John Doe"
```

### AWS S3 Testing

The AWS S3 testing module provides S3 bucket operations and file management testing.

**Key Components:**

- **s3_client.py**: S3 client wrapper
  - Boto3 wrapper with simplified interface
  - Error handling and logging
  - Retry logic for failed operations

- **s3_operations.py**: S3 operations
  - Upload files and directories
  - Download files and objects
  - List, copy, move, delete operations
  - Multipart upload for large files

- **Validators**: S3 validators
  - `bucket_validator.py`: Bucket existence, versioning, encryption
  - `file_validator.py`: File existence, size, checksum, content type
  - `permission_validator.py`: ACL, bucket policies, access

- **Utilities**:
  - `file_handler.py`: Local file operations, temp file management
  - `bucket_manager.py`: Bucket creation, configuration, cleanup
  - `metadata_handler.py`: Object metadata, tags, lifecycle policies

**Example Usage:**
```python
from src.aws_s3.s3_client import S3Client
from src.aws_s3.s3_operations import S3Operations
from src.aws_s3.validators.file_validator import FileValidator

s3 = S3Client(region="us-east-1")
ops = S3Operations(s3)
ops.upload_file("local_file.txt", "my-bucket", "remote_file.txt")

validator = FileValidator(s3)
assert validator.file_exists("my-bucket", "remote_file.txt")
assert validator.get_file_size("my-bucket", "remote_file.txt") > 0
```

## Configuration

### config.yaml
Main configuration file for timeouts, wait conditions, and logging levels.

### environments.yaml
Environment-specific settings for different test environments (dev, staging, production).

### Test Data
Test data is defined in `config/test_data.yaml` and `tests/fixtures/` directory.

## Running Tests

### Run all tests
```bash
pytest
```

### Run specific test module
```bash
# Web automation tests
pytest tests/web_automation_tests/

# API tests
pytest tests/api_tests/

# Database tests
pytest tests/database_tests/

# AWS S3 tests
pytest tests/aws_s3_tests/
```

### Run specific test file
```bash
pytest tests/web_automation_tests/test_login.py
```

### Run with specific markers
```bash
# Run only smoke tests
pytest -m smoke

# Run only regression tests
pytest -m regression
```

### Generate test report
```bash
pytest --html=reports/report.html --self-contained-html
```

### Run with verbose output
```bash
pytest -v
```

### Run with coverage report
```bash
pytest --cov=src --cov-report=html
```

## Contributing

1. Create a new branch for your feature
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes and commit
   ```bash
   git commit -am "Add your message here"
   ```

3. Push to the branch
   ```bash
   git push origin feature/your-feature-name
   ```

4. Create a Pull Request

## Best Practices

- Follow PEP 8 style guidelines
- Write descriptive test names
- Use Page Object Model for web automation
- Keep tests independent and isolated
- Use fixtures for common setup
- Document complex logic
- Use meaningful variable names
- Implement proper error handling

## Troubleshooting

### WebDriver issues
- Ensure ChromeDriver version matches your Chrome browser version
- Check that the driver file has execute permissions

### Database connection issues
- Verify credentials in .env file
- Ensure database server is running
- Check network connectivity

### AWS S3 issues
- Verify AWS credentials are correct
- Ensure IAM user has required S3 permissions
- Check AWS region configuration

## Support

For issues, questions, or suggestions, please create an issue in the GitHub repository.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Last Updated**: 2025-12-26
**Author**: POC-Robot Team
