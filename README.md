# Municipal Complaint Management System

A comprehensive microservices-based online complaint management system designed for municipalities to handle citizen complaints efficiently. The system provides secure registration, complaint tracking, department management, notifications, and API gateway functionalities with robust security and validation.

## 🏗️ Architecture Overview

The system is built using a microservices architecture with the following components:

### Core Services
- **Eureka Server** (Port 8761) - Service Discovery
- **Config Server** (Port 8888) - Centralized Configuration Management
- **API Gateway** (Port 8080) - Entry point with JWT authentication and routing
- **User Service** (Port 8081) - User management with role-based access control
- **Complaint Service** (Port 8082) - Complaint CRUD operations and tracking
- **Department Service** (Port 8083) - Department and staff management
- **Notification Service** (Port 8084) - Email and SMS notifications

### Database
- **MySQL 8.0** - Persistent data storage for all services

## 🚀 Features

### User Management
- **Secure Registration & Login**: BCrypt password hashing with JWT authentication
- **Role-based Access Control**: Three user roles (Citizen, Municipal Staff, Admin)
- **Custom Dashboards**: Role-specific access to different functionalities
- **User Profile Management**: Update profile information and credentials

### Complaint Management
- **Complaint Submission**: Citizens can file complaints with predefined categories
- **Status Tracking**: Real-time tracking of complaint status
- **Comment System**: Citizens, staff, and admins can add comments
- **Department Assignment**: Staff can assign complaints to relevant departments
- **Staff Assignment**: Complaints can be assigned to specific staff members

### Department Management
- **Department CRUD**: Create and manage municipal departments
- **Staff Assignment**: Assign staff members to departments
- **Contact Information**: Maintain department contact details

### Notification System
- **Email Notifications**: Automated emails for status updates and assignments
- **SMS Support**: Ready for SMS integration
- **Real-time Updates**: Instant notifications on complaint changes

### Security Features
- **JWT Authentication**: Secure token-based authentication
- **Role-based Authorization**: Method-level security with @PreAuthorize
- **API Gateway Security**: Centralized authentication enforcement
- **Input Validation**: Bean validation for all inputs

## 📋 Prerequisites

- Java 17 or higher
- Maven 3.6+
- Docker & Docker Compose
- MySQL 8.0 (if running without Docker)

## 🛠️ Quick Start

### Using Docker Compose (Recommended)

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd complaint-management-system
   ```

2. **Set environment variables** (optional)
   ```bash
   export EMAIL_USERNAME=your-email@gmail.com
   export EMAIL_PASSWORD=your-app-password
   ```

3. **Build and run all services**
   ```bash
   # Build all services
   mvn clean package -DskipTests

   # Start all services with Docker Compose
   docker-compose up -d
   ```

4. **Verify services are running**
   ```bash
   # Check service status
   docker-compose ps

   # View logs
   docker-compose logs -f
   ```

### Manual Setup

1. **Start MySQL Database**
   ```bash
   docker run -d \
     --name municipality-mysql \
     -e MYSQL_ROOT_PASSWORD=password \
     -e MYSQL_DATABASE=municipality_db \
     -p 3306:3306 \
     mysql:8.0
   ```

2. **Build all services**
   ```bash
   mvn clean package -DskipTests
   ```

3. **Start services in order**
   ```bash
   # 1. Eureka Server
   java -jar eureka-server/target/eureka-server-1.0.0.jar

   # 2. Config Server
   java -jar config-server/target/config-server-1.0.0.jar

   # 3. API Gateway
   java -jar api-gateway/target/api-gateway-1.0.0.jar

   # 4. Microservices (in parallel)
   java -jar user-service/target/user-service-1.0.0.jar
   java -jar complaint-service/target/complaint-service-1.0.0.jar
   java -jar department-service/target/department-service-1.0.0.jar
   java -jar notification-service/target/notification-service-1.0.0.jar
   ```

## 📡 Service Endpoints

### API Gateway (Entry Point): http://localhost:8080

All requests should go through the API Gateway:

### User Service Endpoints
```
POST /api/users/register          - User registration
POST /api/users/login            - User login
GET  /api/users/profile          - Get current user profile
GET  /api/users/all              - Get all users (Admin only)
GET  /api/users/role/{role}      - Get users by role
PUT  /api/users/{id}             - Update user (Admin only)
DELETE /api/users/{id}           - Delete user (Admin only)
```

### Complaint Service Endpoints
```
POST /api/complaints/create           - Create complaint (Citizen)
GET  /api/complaints/{id}            - Get complaint by ID
GET  /api/complaints/all             - Get all complaints (Staff/Admin)
GET  /api/complaints/my-complaints   - Get citizen's complaints
GET  /api/complaints/status/{status} - Get complaints by status
PUT  /api/complaints/{id}/status     - Update complaint status
PUT  /api/complaints/{id}/assign-department - Assign to department
POST /api/complaints/{id}/comments   - Add comment
```

### Department Service Endpoints
```
POST /api/departments/create     - Create department
GET  /api/departments/all        - Get all departments
GET  /api/departments/{id}       - Get department by ID
PUT  /api/departments/{id}       - Update department
POST /api/departments/{id}/assign-staff - Assign staff to department
```

### Notification Service Endpoints
```
POST /api/notifications/email/status-update - Send status update email
POST /api/notifications/email/assignment    - Send assignment notification
```

## 🔐 Authentication & Authorization

### User Roles
- **CITIZEN**: Can create and view own complaints, add comments
- **MUNICIPAL_STAFF**: Can view/manage complaints, assign to departments
- **ADMIN**: Full system access, user management, all operations

### JWT Token Usage
1. **Register/Login** to get JWT token
2. **Include token** in Authorization header: `Authorization: Bearer <token>`
3. **Token contains** user ID, role, and email for downstream services

### Example Registration Request
```json
POST /api/users/register
{
  "name": "John Doe",
  "email": "john@example.com",
  "username": "johndoe",
  "password": "password123",
  "role": "CITIZEN"
}
```

### Example Login Request
```json
POST /api/users/login
{
  "username": "johndoe",
  "password": "password123"
}
```

## 📊 Data Flow Example

1. **Citizen Registration**
   ```
   Client → API Gateway → User Service → MySQL
   ```

2. **Complaint Submission**
   ```
   Client → API Gateway (JWT validation) → Complaint Service → MySQL
                                        → Notification Service → Email
   ```

3. **Status Update**
   ```
   Staff → API Gateway → Complaint Service → MySQL
                      → Notification Service → Email to Citizen
   ```

## 🐳 Docker Configuration

### Services Network
All services run in `municipality-network` for internal communication.

### Data Persistence
- MySQL data persisted in `mysql_data` volume
- Configuration files stored in config server

### Health Checks
- All services include health check endpoints
- Docker Compose monitors service health

## 🔧 Configuration

### Database Configuration
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/{db_name}?createDatabaseIfNotExist=true
    username: root
    password: password
```

### JWT Configuration
```yaml
jwt:
  secret: mySecretKey123456789012345678901234567890
  expiration: 86400000  # 24 hours
```

### Email Configuration
```yaml
spring:
  mail:
    host: smtp.gmail.com
    port: 587
    username: ${EMAIL_USERNAME}
    password: ${EMAIL_PASSWORD}
```

## 🧪 Testing

### Test User Accounts
Create test accounts for different roles:

```bash
# Admin User
curl -X POST http://localhost:8080/api/users/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "System Admin",
    "email": "admin@municipality.com",
    "username": "admin",
    "password": "admin123",
    "role": "ADMIN"
  }'

# Municipal Staff
curl -X POST http://localhost:8080/api/users/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Water Department Staff",
    "email": "water@municipality.com",
    "username": "waterstaff",
    "password": "staff123",
    "role": "MUNICIPAL_STAFF"
  }'

# Citizen
curl -X POST http://localhost:8080/api/users/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Citizen",
    "email": "john@example.com",
    "username": "john",
    "password": "citizen123",
    "role": "CITIZEN"
  }'
```

### Test Complaint Flow
```bash
# 1. Login as citizen
TOKEN=$(curl -X POST http://localhost:8080/api/users/login \
  -H "Content-Type: application/json" \
  -d '{"username": "john", "password": "citizen123"}' \
  | jq -r '.token')

# 2. Create complaint
curl -X POST http://localhost:8080/api/complaints/create \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "category": "WATER",
    "description": "Water leakage in my street causing flooding issues"
  }'
```

## 📈 Monitoring & Management

### Service Discovery
- Eureka Dashboard: http://localhost:8761
- View all registered services and their health status

### Actuator Endpoints
Each service exposes management endpoints:
```
/actuator/health   - Health status
/actuator/info     - Service information
/actuator/metrics  - Service metrics
```

### Gateway Monitoring
- Gateway routes: http://localhost:8080/actuator/gateway/routes
- Circuit breaker status and fallback mechanisms

## 🚨 Troubleshooting

### Common Issues

1. **Services not starting**
   - Check if MySQL is running
   - Verify port availability
   - Check Docker Compose logs

2. **Authentication issues**
   - Verify JWT token format
   - Check token expiration
   - Ensure proper Authorization header

3. **Database connection issues**
   - Check MySQL credentials
   - Verify database URL
   - Ensure database creation permissions

### Service Health Checks
```bash
# Check service health
curl http://localhost:8761/actuator/health  # Eureka
curl http://localhost:8888/actuator/health  # Config Server
curl http://localhost:8080/actuator/health  # API Gateway
curl http://localhost:8081/actuator/health  # User Service
curl http://localhost:8082/actuator/health  # Complaint Service
curl http://localhost:8083/actuator/health  # Department Service
curl http://localhost:8084/actuator/health  # Notification Service
```

## 🔄 Scaling & Production

### Horizontal Scaling
- Multiple instances of each service can be deployed
- Load balancing handled by Eureka and API Gateway
- Database clustering for high availability

### Security Enhancements
- Use environment-specific JWT secrets
- Implement rate limiting
- Add HTTPS/TLS encryption
- Regular security audits

### Monitoring & Logging
- Integrate with ELK stack for centralized logging
- Add Prometheus/Grafana for metrics
- Implement distributed tracing

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request

## 📞 Support

For support and questions, please contact the development team or create an issue in the repository.