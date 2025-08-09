# Municipal Complaint Management System

A comprehensive microservices-based complaint management system for municipalities supporting citizen complaints on public issues like water, sanitation, and roads.

## System Architecture

### Microservices Overview

1. **Eureka Server** (Port 8761) - Service Discovery
2. **Config Server** (Port 8888) - Centralized Configuration
3. **API Gateway** (Port 8080) - Central Entry Point with JWT Authentication
4. **User Service** (Port 8081) - User Management & Authentication
5. **Complaint Service** (Port 8082) - Complaint Management
6. **Department Service** (Port 8083) - Department & Staff Management
7. **Notification Service** (Port 8084) - Email/SMS Notifications

### Technology Stack

- **Framework**: Spring Boot 3.1.5, Spring Cloud 2022.0.4
- **Database**: MySQL 8.0
- **Authentication**: JWT with Spring Security
- **Service Discovery**: Netflix Eureka
- **API Gateway**: Spring Cloud Gateway
- **Configuration**: Spring Cloud Config
- **Containerization**: Docker & Docker Compose

## Features

### User Management
- **Role-based Access Control**: Citizens, Municipal Staff, Admins
- **Secure Registration/Login** with BCrypt password encryption
- **JWT Token Authentication** with 24-hour expiration
- **User Profile Management**

### Complaint Management
- **Citizens** can submit complaints with categories (Water, Sanitation, Roads, etc.)
- **Staff/Admins** can assign complaints to departments and update status
- **Comment System** for tracking conversation and updates
- **Status Tracking**: Submitted → In Progress → Resolved/Rejected → Closed
- **Priority Levels**: Low, Medium, High, Urgent

### Department Management
- **Department Creation** and management
- **Staff Assignment** to specific departments
- **Automated Complaint Routing** based on categories

### Notification System
- **Email Notifications** for complaint status changes
- **Real-time Updates** to users
- **Multiple Notification Types**: Email, SMS, In-App

## Database Schema

### Key Tables
- `users`: User account information with roles
- `departments`: Municipal departments
- `department_staff`: Staff-department assignments
- `complaints`: Complaint details and tracking
- `complaint_comments`: Comment threads
- `complaint_status_history`: Audit trail
- `notifications`: Notification logs

## API Endpoints

### Authentication Endpoints
```
POST /api/users/auth/register - User registration
POST /api/users/auth/login - User login
```

### User Management
```
GET /api/users - Get all users (Admin/Staff only)
GET /api/users/{id} - Get user by ID
PUT /api/users/{id} - Update user profile
DELETE /api/users/{id} - Delete user (Admin only)
```

### Complaint Management
```
GET /api/complaints - Get complaints (filtered by role)
POST /api/complaints - Submit new complaint
GET /api/complaints/{id} - Get complaint details
PUT /api/complaints/{id} - Update complaint
PUT /api/complaints/{id}/assign - Assign to department
POST /api/complaints/{id}/comments - Add comment
```

### Department Management
```
GET /api/departments - Get all departments
POST /api/departments - Create department (Admin only)
PUT /api/departments/{id} - Update department
GET /api/departments/{id}/staff - Get department staff
```

## Security Features

### JWT Authentication
- **Secret Key**: Configurable via properties
- **Token Expiration**: 24 hours (configurable)
- **Role-based Claims**: Embedded in JWT payload
- **Gateway-level Validation**: All requests validated at gateway

### Role-based Access Control
- **Citizens**: Can only access their own complaints and profile
- **Municipal Staff**: Can access assigned complaints and departments
- **Admins**: Full system access and user management

### Data Validation
- **Bean Validation**: @Valid annotations with custom validators
- **Email Format**: Proper email validation
- **Password Strength**: Minimum 6 characters
- **Required Fields**: Username, email, password, name, role

## Setup Instructions

### Prerequisites
- Java 17+
- Maven 3.6+
- Docker & Docker Compose
- MySQL 8.0 (or use Docker MySQL)

### Quick Start with Docker

1. **Clone and Build**
```bash
git clone <repository-url>
cd complaint-management-system
mvn clean package -DskipTests
```

2. **Start Services**
```bash
docker-compose up -d
```

3. **Verify Services**
```bash
# Check Eureka Dashboard
http://localhost:8761

# Check API Gateway
http://localhost:8080

# Check individual services health
curl http://localhost:8081/actuator/health  # User Service
curl http://localhost:8082/actuator/health  # Complaint Service
curl http://localhost:8083/actuator/health  # Department Service
```

### Manual Setup

1. **Start MySQL**
```bash
docker run -d --name mysql-complaint \
  -e MYSQL_ROOT_PASSWORD=root123 \
  -e MYSQL_DATABASE=complaint_system \
  -p 3306:3306 mysql:8.0
```

2. **Initialize Database**
```bash
mysql -h localhost -u root -p complaint_system < sql-scripts/init.sql
```

3. **Start Services in Order**
```bash
# 1. Eureka Server
cd eureka-server && mvn spring-boot:run

# 2. Config Server
cd config-server && mvn spring-boot:run

# 3. API Gateway
cd api-gateway && mvn spring-boot:run

# 4. Business Services (parallel)
cd user-service && mvn spring-boot:run &
cd complaint-service && mvn spring-boot:run &
cd department-service && mvn spring-boot:run &
cd notification-service && mvn spring-boot:run &
```

## Default Users

The system comes with pre-configured users:

### Admin User
- **Username**: admin
- **Password**: admin123
- **Role**: ADMIN

### Municipal Staff
- **Username**: staff.water
- **Password**: admin123
- **Role**: MUNICIPAL_STAFF
- **Department**: Water Works

### Citizen User
- **Username**: john.doe
- **Password**: citizen123
- **Role**: CITIZEN

## API Testing

### Register New Citizen
```bash
curl -X POST http://localhost:8080/api/users/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "jane.doe",
    "email": "jane@email.com",
    "password": "password123",
    "name": "Jane Doe",
    "role": "CITIZEN",
    "phone": "1234567890",
    "address": "456 Oak Street"
  }'
```

### Login
```bash
curl -X POST http://localhost:8080/api/users/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "jane.doe",
    "password": "password123"
  }'
```

### Submit Complaint (with JWT token)
```bash
curl -X POST http://localhost:8080/api/complaints \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT_TOKEN>" \
  -d '{
    "title": "Water Supply Issue",
    "description": "No water supply in our area for 3 days",
    "category": "WATER",
    "location": "Block A, Sector 15"
  }'
```

## Configuration

### Environment Variables
- `MYSQL_HOST`: Database host (default: localhost)
- `MYSQL_PORT`: Database port (default: 3306)
- `MYSQL_DB`: Database name (default: complaint_system)
- `MYSQL_USER`: Database username (default: root)
- `MYSQL_PASSWORD`: Database password (default: root123)
- `JWT_SECRET`: JWT signing secret (default: provided in config)
- `MAIL_USERNAME`: SMTP email username
- `MAIL_PASSWORD`: SMTP email password

### Service Ports
- **Eureka Server**: 8761
- **Config Server**: 8888
- **API Gateway**: 8080
- **User Service**: 8081
- **Complaint Service**: 8082
- **Department Service**: 8083
- **Notification Service**: 8084
- **MySQL Database**: 3306

## Development

### Adding New Features
1. Create feature branch from main
2. Implement changes in relevant microservice
3. Update API documentation
4. Add tests
5. Update configuration if needed
6. Submit pull request

### Debugging
- **Service Logs**: Check individual service logs
- **Eureka Dashboard**: Monitor service registration
- **Actuator Endpoints**: Health checks and metrics
- **Database**: Check MySQL logs and queries

## Production Deployment

### Considerations
- **Load Balancing**: Use multiple instances behind load balancer
- **Database**: Use managed MySQL service or cluster
- **Security**: Use proper SSL certificates
- **Monitoring**: Implement comprehensive logging and monitoring
- **Backup**: Regular database and configuration backups

### Scaling
- **Horizontal Scaling**: Run multiple instances of each service
- **Database Scaling**: Read replicas and connection pooling
- **Caching**: Implement Redis for session and data caching
- **CDN**: Use CDN for static assets

## Troubleshooting

### Common Issues

1. **Service Discovery Issues**
   - Check Eureka server status
   - Verify service registration
   - Check network connectivity

2. **Database Connection**
   - Verify MySQL is running
   - Check connection credentials
   - Ensure database schema exists

3. **JWT Authentication**
   - Verify token expiration
   - Check JWT secret configuration
   - Validate token format

4. **Configuration Issues**
   - Check Config Server accessibility
   - Verify configuration files
   - Check environment variables

## Contributing

1. Fork the repository
2. Create feature branch
3. Commit changes with descriptive messages
4. Push to the branch
5. Create Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create GitHub issues for bugs
- Check documentation for setup help
- Review logs for troubleshooting