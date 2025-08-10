# MySQL Database Setup Guide for Municipality Complaint System

## Overview

This guide explains how to set up MySQL databases for all microservices in the Municipality Complaint System. Each microservice has its own database for data isolation and scalability.

## Prerequisites

- MySQL 8.0 or higher installed
- MySQL server running on localhost:3306
- Root access to MySQL (or create a dedicated user)

## Database Architecture

The system uses **4 separate databases** for different microservices:

1. **`user_service`** - User management and authentication
2. **`complaint_service`** - Complaint tracking and management
3. **`department_service`** - Department and staff management
4. **`notification_service`** - Notification logs and templates

## Step 1: Install MySQL

### Ubuntu/Debian
```bash
sudo apt update
sudo apt install mysql-server
sudo systemctl start mysql
sudo systemctl enable mysql
```

### CentOS/RHEL
```bash
sudo yum install mysql-server
sudo systemctl start mysqld
sudo systemctl enable mysqld
```

### macOS (using Homebrew)
```bash
brew install mysql
brew services start mysql
```

### Windows
Download and install MySQL from [mysql.com](https://dev.mysql.com/downloads/mysql/)

## Step 2: Secure MySQL Installation

```bash
# Secure the installation
sudo mysql_secure_installation

# Or manually set root password
sudo mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'your_secure_password';
FLUSH PRIVILEGES;
EXIT;
```

## Step 3: Create Database User (Recommended)

Instead of using root, create a dedicated user:

```sql
-- Login to MySQL as root
mysql -u root -p

-- Create dedicated user
CREATE USER 'municipality_user'@'localhost' IDENTIFIED BY 'municipality_password';

-- Grant permissions to all databases
GRANT ALL PRIVILEGES ON user_service.* TO 'municipality_user'@'localhost';
GRANT ALL PRIVILEGES ON complaint_service.* TO 'municipality_user'@'localhost';
GRANT ALL PRIVILEGES ON department_service.* TO 'municipality_user'@'localhost';
GRANT ALL PRIVILEGES ON notification_service.* TO 'municipality_user'@'localhost';

-- Grant permission to create databases
GRANT CREATE ON *.* TO 'municipality_user'@'localhost';

FLUSH PRIVILEGES;
EXIT;
```

## Step 4: Update Configuration Files

Update the configuration files to use the new user credentials:

### Update `config/user-service.properties`:
```properties
# Database Configuration
spring.datasource.url=jdbc:mysql://localhost:3306/user_service?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true
spring.datasource.username=municipality_user
spring.datasource.password=municipality_password
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```

### Update `config/complaint-service.properties`:
```properties
# Database Configuration
spring.datasource.url=jdbc:mysql://localhost:3306/complaint_service?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true
spring.datasource.username=municipality_user
spring.datasource.password=municipality_password
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```

### Update `config/department-service.properties`:
```properties
# Database Configuration
spring.datasource.url=jdbc:mysql://localhost:3306/department_service?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true
spring.datasource.username=municipality_user
spring.datasource.password=municipality_password
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```

### Update `config/notification-service.properties`:
```properties
# Database Configuration
spring.datasource.url=jdbc:mysql://localhost:3306/notification_service?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true
spring.datasource.username=municipality_user
spring.datasource.password=municipality_password
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```

## Step 5: Database Initialization Scripts

### Create Initial Database Schema

```sql
-- Login to MySQL
mysql -u municipality_user -p

-- Create databases (if not using auto-creation)
CREATE DATABASE IF NOT EXISTS user_service;
CREATE DATABASE IF NOT EXISTS complaint_service;
CREATE DATABASE IF NOT EXISTS department_service;
CREATE DATABASE IF NOT EXISTS notification_service;

-- Use user_service
USE user_service;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    role ENUM('CITIZEN', 'STAFF', 'SUPERVISOR', 'MANAGER', 'ADMIN') NOT NULL,
    department_id BIGINT,
    status ENUM('ACTIVE', 'INACTIVE', 'SUSPENDED') DEFAULT 'ACTIVE',
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL
);

-- Create departments table
CREATE TABLE IF NOT EXISTS departments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Use complaint_service
USE complaint_service;

-- Create complaints table
CREATE TABLE IF NOT EXISTS complaints (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    category ENUM('WATER', 'SANITATION', 'ROADS', 'ELECTRICAL', 'GENERAL') NOT NULL,
    priority ENUM('LOW', 'MEDIUM', 'HIGH', 'URGENT') DEFAULT 'MEDIUM',
    status ENUM('SUBMITTED', 'ASSIGNED', 'IN_PROGRESS', 'RESOLVED', 'CLOSED') DEFAULT 'SUBMITTED',
    citizen_id BIGINT NOT NULL,
    assigned_department_id BIGINT,
    assigned_staff_id BIGINT,
    location VARCHAR(255),
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP NULL
);

-- Create comments table
CREATE TABLE IF NOT EXISTS comments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    complaint_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (complaint_id) REFERENCES complaints(id) ON DELETE CASCADE
);

-- Use department_service
USE department_service;

-- Create departments table
CREATE TABLE IF NOT EXISTS departments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    manager_id BIGINT,
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create staff table
CREATE TABLE IF NOT EXISTS staff (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    department_id BIGINT NOT NULL,
    position VARCHAR(100),
    hire_date DATE,
    status ENUM('ACTIVE', 'INACTIVE', 'ON_LEAVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

-- Use notification_service
USE notification_service;

-- Create notifications table
CREATE TABLE IF NOT EXISTS notifications (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    type ENUM('EMAIL', 'SMS', 'PUSH') NOT NULL,
    title VARCHAR(200),
    message TEXT NOT NULL,
    status ENUM('PENDING', 'SENT', 'FAILED') DEFAULT 'PENDING',
    sent_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create notification_templates table
CREATE TABLE IF NOT EXISTS notification_templates (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type ENUM('EMAIL', 'SMS') NOT NULL,
    subject VARCHAR(200),
    body TEXT NOT NULL,
    variables JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert sample data
USE user_service;

-- Insert sample departments
INSERT INTO departments (name, description) VALUES
('Water Works', 'Manages water supply and maintenance'),
('Sanitation', 'Handles waste management and cleaning'),
('Roads Maintenance', 'Road repairs and maintenance'),
('Electrical', 'Street lighting and electrical issues'),
('General', 'General municipal services');

-- Insert sample admin user (password: admin123)
INSERT INTO users (username, email, password, name, role, status) VALUES
('admin', 'admin@municipality.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'System Administrator', 'ADMIN', 'ACTIVE');

-- Insert sample staff users
INSERT INTO users (username, email, password, name, role, department_id, status) VALUES
('manager1', 'manager1@municipality.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'John Manager', 'MANAGER', 1, 'ACTIVE'),
('staff1', 'staff1@municipality.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'Jane Staff', 'STAFF', 1, 'ACTIVE');

-- Insert sample citizen
INSERT INTO users (username, email, password, name, role, status) VALUES
('citizen1', 'citizen1@example.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'John Citizen', 'CITIZEN', 'ACTIVE');

-- Use complaint_service
USE complaint_service;

-- Insert sample complaints
INSERT INTO complaints (title, description, category, priority, citizen_id, status) VALUES
('Water Supply Issue', 'No water supply in my area for the past 2 days', 'WATER', 'HIGH', 4, 'SUBMITTED'),
('Road Pothole', 'Large pothole on Main Street causing traffic issues', 'ROADS', 'MEDIUM', 4, 'SUBMITTED');

-- Use department_service
USE department_service;

-- Insert sample departments
INSERT INTO departments (name, description) VALUES
('Water Works', 'Manages water supply and maintenance'),
('Sanitation', 'Handles waste management and cleaning'),
('Roads Maintenance', 'Road repairs and maintenance'),
('Electrical', 'Street lighting and electrical issues'),
('General', 'General municipal services');

-- Insert sample staff
INSERT INTO staff (user_id, department_id, position, hire_date) VALUES
(2, 1, 'Department Manager', '2023-01-15'),
(3, 1, 'Field Staff', '2023-02-01');

-- Use notification_service
USE notification_service;

-- Insert sample notification templates
INSERT INTO notification_templates (name, type, subject, body) VALUES
('Complaint Submitted', 'EMAIL', 'Complaint Submitted Successfully', 'Dear {{citizenName}}, Your complaint regarding {{issue}} has been submitted successfully. Complaint ID: {{complaintId}}'),
('Complaint Status Update', 'EMAIL', 'Complaint Status Updated', 'Dear {{citizenName}}, Your complaint (ID: {{complaintId}}) status has been updated to {{status}}');

-- Show all databases
SHOW DATABASES;

-- Show tables in each database
SELECT 'user_service' as database_name, table_name FROM information_schema.tables WHERE table_schema = 'user_service'
UNION ALL
SELECT 'complaint_service' as database_name, table_name FROM information_schema.tables WHERE table_schema = 'complaint_service'
UNION ALL
SELECT 'department_service' as database_name, table_name FROM information_schema.tables WHERE table_schema = 'department_service'
UNION ALL
SELECT 'notification_service' as database_name, table_name FROM information_schema.tables WHERE table_schema = 'notification_service';
```

## Step 6: Verify Database Connection

### Test Connection from Command Line
```bash
# Test connection to each database
mysql -u municipality_user -p -h localhost -P 3306 user_service
mysql -u municipality_user -p -h localhost -P 3306 complaint_service
mysql -u municipality_user -p -h localhost -P 3306 department_service
mysql -u municipality_user -p -h localhost -P 3306 notification_service
```

### Test from Application
Start the microservices and check the logs for successful database connections.

## Step 7: Environment Variables (Alternative)

Instead of hardcoding credentials, you can use environment variables:

### Update `config/user-service.properties`:
```properties
# Database Configuration
spring.datasource.url=jdbc:mysql://${DB_HOST:localhost}:${DB_PORT:3306}/${DB_NAME:user_service}?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true
spring.datasource.username=${DB_USERNAME:municipality_user}
spring.datasource.password=${DB_PASSWORD:municipality_password}
```

### Set Environment Variables:
```bash
export DB_HOST=localhost
export DB_PORT=3306
export DB_USERNAME=municipality_user
export DB_PASSWORD=municipality_password
```

## Step 8: Docker MySQL Setup (Alternative)

If you prefer using Docker:

```bash
# Create MySQL container
docker run --name municipality-mysql \
  -e MYSQL_ROOT_PASSWORD=rootpassword \
  -e MYSQL_DATABASE=municipality \
  -e MYSQL_USER=municipality_user \
  -e MYSQL_PASSWORD=municipality_password \
  -p 3306:3306 \
  -d mysql:8.0

# Update configuration to use Docker host
spring.datasource.url=jdbc:mysql://localhost:3306/user_service?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true
```

## Troubleshooting

### Common Issues:

1. **Connection Refused**
   - Check if MySQL is running: `sudo systemctl status mysql`
   - Verify port 3306 is open: `netstat -tlnp | grep 3306`

2. **Access Denied**
   - Verify username/password
   - Check user permissions: `SHOW GRANTS FOR 'municipality_user'@'localhost';`

3. **Database Not Found**
   - Create database manually: `CREATE DATABASE user_service;`
   - Check if `createDatabaseIfNotExist=true` is in URL

4. **SSL Issues**
   - Add `useSSL=false` to connection URL
   - Add `allowPublicKeyRetrieval=true` for MySQL 8.0+

### Check MySQL Status:
```bash
# Check MySQL service status
sudo systemctl status mysql

# Check MySQL process
ps aux | grep mysql

# Check MySQL port
sudo netstat -tlnp | grep 3306

# Check MySQL error logs
sudo tail -f /var/log/mysql/error.log
```

## Security Best Practices

1. **Use Dedicated User**: Don't use root for applications
2. **Strong Passwords**: Use complex passwords
3. **Limit Permissions**: Grant only necessary permissions
4. **Network Security**: Restrict access to localhost only
5. **Regular Updates**: Keep MySQL updated
6. **Backup Strategy**: Regular database backups

## Next Steps

After setting up MySQL:

1. **Start Config Server**: `cd config-server && mvn spring-boot:run`
2. **Start Eureka Server**: `cd eureka-server && mvn spring-boot:run`
3. **Start Microservices**: Start each service in order
4. **Test Database**: Verify data is being created and accessed

The system will automatically create tables and insert sample data when the services start up.