# MySQL Quick Reference - Municipality Complaint System

## Current Configuration

All microservices are configured to connect to MySQL with these settings:

### Database Connection Details
- **Host**: `localhost`
- **Port**: `3306`
- **Username**: `municipality_user`
- **Password**: `municipality_password`

### Database Names
1. **`user_service`** - Port 8081
2. **`complaint_service`** - Port 8082  
3. **`department_service`** - Port 8083
4. **`notification_service`** - Port 8084

## Quick Setup Commands

### 1. Run Automated Setup Script
```bash
./setup_mysql.sh
```

### 2. Manual MySQL Installation (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install mysql-server
sudo systemctl start mysql
sudo systemctl enable mysql
sudo mysql_secure_installation
```

### 3. Create User and Databases Manually
```bash
# Login to MySQL as root
mysql -u root -p

# Create user and databases
CREATE USER 'municipality_user'@'localhost' IDENTIFIED BY 'municipality_password';
CREATE DATABASE user_service;
CREATE DATABASE complaint_service;
CREATE DATABASE department_service;
CREATE DATABASE notification_service;

# Grant permissions
GRANT ALL PRIVILEGES ON user_service.* TO 'municipality_user'@'localhost';
GRANT ALL PRIVILEGES ON complaint_service.* TO 'municipality_user'@'localhost';
GRANT ALL PRIVILEGES ON department_service.* TO 'municipality_user'@'localhost';
GRANT ALL PRIVILEGES ON notification_service.* TO 'municipality_user'@'localhost';
GRANT CREATE ON *.* TO 'municipality_user'@'localhost';

FLUSH PRIVILEGES;
EXIT;
```

## Test Database Connections

### Test Each Database
```bash
# Test user_service
mysql -u municipality_user -p -h localhost -P 3306 user_service

# Test complaint_service  
mysql -u municipality_user -p -h localhost -P 3306 complaint_service

# Test department_service
mysql -u municipality_user -p -h localhost -P 3306 department_service

# Test notification_service
mysql -u municipality_user -p -h localhost -P 3306 notification_service
```

### Test from Application
```bash
# Start config server first
cd config-server && mvn spring-boot:run

# Start eureka server
cd eureka-server && mvn spring-boot:run

# Start a microservice (e.g., user-service)
cd user-service && mvn spring-boot:run
```

## Configuration Files

### Current Database Configuration
All services use the config server. Database settings are in:

- `config/user-service.properties`
- `config/complaint-service.properties`  
- `config/department-service.properties`
- `config/notification-service.properties`

### Key Properties
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/user_service?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true
spring.datasource.username=municipality_user
spring.datasource.password=municipality_password
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.jpa.hibernate.ddl-auto=update
```

## Troubleshooting

### Common Issues & Solutions

#### 1. Connection Refused
```bash
# Check if MySQL is running
sudo systemctl status mysql

# Start MySQL if stopped
sudo systemctl start mysql

# Check port
sudo netstat -tlnp | grep 3306
```

#### 2. Access Denied
```bash
# Check user permissions
mysql -u root -p
SHOW GRANTS FOR 'municipality_user'@'localhost';

# Reset user password if needed
ALTER USER 'municipality_user'@'localhost' IDENTIFIED BY 'municipality_password';
FLUSH PRIVILEGES;
```

#### 3. Database Not Found
```bash
# Create database manually
mysql -u municipality_user -p
CREATE DATABASE user_service;
CREATE DATABASE complaint_service;
CREATE DATABASE department_service;
CREATE DATABASE notification_service;
```

#### 4. SSL Issues
Add these parameters to connection URL:
- `useSSL=false`
- `allowPublicKeyRetrieval=true`

## Sample Data

After setup, you'll have:

### Default Users
- **Admin**: `admin` / `admin123`
- **Manager**: `manager1` / `admin123`
- **Staff**: `staff1` / `admin123`
- **Citizen**: `citizen1` / `admin123`

### Sample Departments
- Water Works
- Sanitation  
- Roads Maintenance
- Electrical
- General

### Sample Complaints
- Water supply issues
- Road potholes

## Environment Variables (Alternative)

Instead of hardcoded credentials:

```bash
export DB_HOST=localhost
export DB_PORT=3306
export DB_USERNAME=municipality_user
export DB_PASSWORD=municipality_password
```

Update config files to use:
```properties
spring.datasource.url=jdbc:mysql://${DB_HOST:localhost}:${DB_PORT:3306}/${DB_NAME:user_service}?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true
spring.datasource.username=${DB_USERNAME:municipality_user}
spring.datasource.password=${DB_PASSWORD:municipality_password}
```

## Docker Alternative

```bash
# Run MySQL in Docker
docker run --name municipality-mysql \
  -e MYSQL_ROOT_PASSWORD=rootpassword \
  -e MYSQL_USER=municipality_user \
  -e MYSQL_PASSWORD=municipality_password \
  -p 3306:3306 \
  -d mysql:8.0

# Update config to use localhost:3306
```

## Next Steps After MySQL Setup

1. **Start Config Server** (Port 8888)
2. **Start Eureka Server** (Port 8761)  
3. **Start Microservices** in order
4. **Access JSP UI** at `http://localhost:8081`
5. **Login** with admin/admin123

## Support

If you encounter issues:
1. Check MySQL service status
2. Verify user permissions
3. Check application logs
4. Ensure all required ports are available
5. Verify database names match configuration