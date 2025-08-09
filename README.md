# Municipal Complaint Management System

A comprehensive microservices-based online complaint management system for municipalities that supports citizen complaints on public issues like water, sanitation, and roads. The system ensures secure registration, complaint tracking, department management, notifications, and API gateway functionalities with robust security and validation.

## 🏗️ System Architecture

The system follows a microservices architecture with the following components:

### Core Infrastructure
- **Eureka Server**: Service discovery and registration
- **Config Server**: Centralized configuration management
- **API Gateway**: Single entry point with routing, security, and rate limiting

### Business Services
- **User Service**: User management, authentication, and authorization
- **Complaint Service**: Complaint lifecycle management
- **Department Service**: Municipal department management
- **Notification Service**: Email and SMS notifications

### Databases
- **MySQL**: Separate databases for each service
- **Redis**: Caching and rate limiting

## 🚀 Features

### User Management
- ✅ Secure user registration for Citizens, Municipal Staff, and Admins
- ✅ JWT-based authentication and authorization
- ✅ Role-based access control (RBAC)
- ✅ BCrypt password encryption
- ✅ Custom dashboards for different user roles

### Complaint Management
- ✅ Citizen complaint submission with predefined categories
- ✅ Real-time complaint status tracking
- ✅ Comment threads for communication
- ✅ Department and staff assignment
- ✅ Priority management
- ✅ Comprehensive complaint search and filtering

### Security & Validation
- ✅ JWT token authentication across all services
- ✅ Spring Security with method-level authorization
- ✅ Bean Validation for all input data
- ✅ CORS configuration for web clients
- ✅ API Gateway security enforcement

### System Integration
- ✅ Service discovery with Eureka
- ✅ Centralized configuration
- ✅ API Gateway routing and rate limiting
- ✅ Docker containerization
- ✅ Health checks and monitoring

## 📋 Prerequisites

- Java 17 or higher
- Maven 3.6 or higher
- Docker and Docker Compose
- MySQL 8.0 (or use Docker containers)

## 🛠️ Quick Start

### 1. Clone the Repository
```bash
git clone <repository-url>
cd complaint-management-system
```

### 2. Build the Project
```bash
mvn clean install
```

### 3. Start with Docker Compose
```bash
docker-compose up -d
```

This will start all services including:
- MySQL databases (ports 3307, 3308, 3309)
- Redis (port 6379)
- Eureka Server (port 8761)
- Config Server (port 8888)
- API Gateway (port 8080)
- All microservices

### 4. Verify Services
- Eureka Dashboard: http://localhost:8761
- API Gateway: http://localhost:8080
- Individual services: http://localhost:808x

## 🔧 Service Configuration

### Port Configuration
| Service | Port | Description |
|---------|------|-------------|
| API Gateway | 8080 | Main entry point |
| User Service | 8081 | User management |
| Complaint Service | 8082 | Complaint handling |
| Department Service | 8083 | Department management |
| Notification Service | 8084 | Notifications |
| Config Server | 8888 | Configuration |
| Eureka Server | 8761 | Service discovery |

### Database Configuration
| Database | Port | Service |
|----------|------|---------|
| user_db | 3307 | User Service |
| complaint_db | 3308 | Complaint Service |
| department_db | 3309 | Department Service |

## 📚 API Documentation

### Authentication Endpoints
```http
POST /api/users/register
POST /api/users/login
GET  /api/users/profile/{username}
GET  /api/users/dashboard
```

### Complaint Management
```http
POST /api/complaints
GET  /api/complaints
GET  /api/complaints/{id}
PUT  /api/complaints/{id}/status
PUT  /api/complaints/{id}/assign-department
PUT  /api/complaints/{id}/assign-staff
POST /api/complaints/{id}/comments
```

### Department Management
```http
GET  /api/departments
POST /api/departments
PUT  /api/departments/{id}
GET  /api/departments/{id}/staff
```

### Notifications
```http
POST /api/notifications/email
POST /api/notifications/sms
```

## 🔐 Security Features

### JWT Authentication
- Token-based authentication
- Role-based authorization
- Secure token validation across services
- Configurable token expiration

### Role-Based Access Control
- **CITIZEN**: Can create and view own complaints, add comments
- **MUNICIPAL_STAFF**: Can view assigned complaints, update status, add comments
- **ADMIN**: Full system access, user management, complaint assignment

### Data Validation
- Bean Validation annotations
- Custom validators for complex business rules
- Input sanitization and validation
- Secure password requirements

## 🏃‍♂️ Development Setup

### Local Development
1. Start infrastructure services:
   ```bash
   docker-compose up -d eureka-server config-server user-db complaint-db department-db redis
   ```

2. Run services individually:
   ```bash
   cd user-service && mvn spring-boot:run
   cd complaint-service && mvn spring-boot:run
   cd department-service && mvn spring-boot:run
   cd notification-service && mvn spring-boot:run
   cd api-gateway && mvn spring-boot:run
   ```

### Testing
```bash
# Run all tests
mvn test

# Run tests for specific service
cd user-service && mvn test
```

## 📊 Monitoring and Health Checks

### Health Endpoints
- `/actuator/health` - Service health status
- `/actuator/info` - Service information

### Eureka Dashboard
Access the Eureka dashboard at http://localhost:8761 to monitor service registration and health.

## 🔄 Data Flow Example

1. **Citizen Registration**: 
   - Citizen registers via API Gateway → User Service
   - JWT token generated and returned

2. **Complaint Submission**:
   - Citizen submits complaint via API Gateway → Complaint Service
   - Complaint stored with status "SUBMITTED"

3. **Complaint Assignment**:
   - Admin/Staff assigns complaint via Complaint Service → Department Service
   - Status updated to "UNDER_REVIEW"

4. **Status Updates**:
   - Staff updates complaint status
   - Notification Service sends updates to citizen

## 🛡️ Security Considerations

### Production Deployment
- Change default passwords and secrets
- Use environment-specific configurations
- Enable HTTPS/TLS
- Configure proper database security
- Set up monitoring and logging
- Implement API rate limiting
- Use secrets management

### Configuration Security
- Store sensitive data in environment variables
- Use Spring Cloud Config encryption
- Implement proper certificate management
- Configure security headers

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation wiki

---

**Municipal Complaint Management System** - Empowering citizens and streamlining municipal operations through technology.