# Municipal Complaint Management System - Architecture Overview

## 🏗️ System Architecture

This is a comprehensive microservices-based complaint management system designed for municipalities to efficiently handle citizen complaints regarding public services.

### 🎯 Core Design Principles

1. **Microservices Architecture**: Each service has a single responsibility
2. **Security First**: JWT-based authentication with role-based access control
3. **Scalability**: Services can be scaled independently
4. **Resilience**: Service discovery and configuration management
5. **Data Integrity**: Comprehensive validation and audit trails

## 🔧 Technical Implementation

### Service Discovery & Configuration
```
┌─────────────────┐    ┌──────────────────┐
│  Eureka Server  │    │  Config Server   │
│     :8761       │    │      :8888       │
│                 │    │                  │
│ Service         │    │ Centralized      │
│ Registration    │    │ Configuration    │
│ & Discovery     │    │ Management       │
└─────────────────┘    └──────────────────┘
```

### API Gateway & Security
```
                    ┌──────────────────┐
                    │   API Gateway    │
                    │      :8080       │
                    │                  │
┌─────────────────► │ • JWT Validation │
│  External         │ • Request Routing│
│  Requests         │ • CORS Handling  │
│                   │ • Rate Limiting  │
└─────────────────► └──────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │  Internal        │
                    │  Services        │
                    └──────────────────┘
```

### Business Services
```
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│   User Service  │  │Complaint Service│  │Department Service│
│     :8081       │  │     :8082       │  │     :8083       │
│                 │  │                 │  │                 │
│ • Authentication│  │ • Complaint CRUD│  │ • Dept Management│
│ • User Management│  │ • Status Updates│  │ • Staff Assignment│
│ • JWT Generation│  │ • Comment System│  │ • Auto Routing  │
│ • Role Management│  │ • Assignment    │  │                 │
└─────────────────┘  └─────────────────┘  └─────────────────┘
                              │
                              ▼
                    ┌─────────────────┐
                    │Notification Svc │
                    │     :8084       │
                    │                 │
                    │ • Email Alerts  │
                    │ • SMS Notifications│
                    │ • Status Updates│
                    └─────────────────┘
```

### Database Architecture
```
                    ┌──────────────────┐
                    │      MySQL       │
                    │      :3306       │
                    │                  │
                    │ ┌──────────────┐ │
                    │ │    users     │ │
                    │ │ departments  │ │
                    │ │ complaints   │ │
                    │ │ comments     │ │
                    │ │ notifications│ │
                    │ │ audit_logs   │ │
                    │ └──────────────┘ │
                    └──────────────────┘
```

## 🔐 Security Model

### Authentication Flow
```
1. User Login → User Service
2. JWT Generation (with roles)
3. JWT sent to client
4. Client includes JWT in requests
5. API Gateway validates JWT
6. Gateway adds user context headers
7. Services receive authenticated requests
```

### Authorization Matrix
| Role            | Own Profile | All Users | Complaints | Departments | System Admin |
|----------------|-------------|-----------|------------|-------------|--------------|
| **CITIZEN**    | ✅ Read/Write| ❌ No     | ✅ Own Only| ❌ No       | ❌ No        |
| **MUNICIPAL_STAFF** | ✅ Read/Write| ✅ Read   | ✅ Assigned| ✅ Assigned | ❌ No        |
| **ADMIN**      | ✅ Read/Write| ✅ All    | ✅ All     | ✅ All      | ✅ All       |

## 📊 Data Flow Examples

### Complaint Submission Flow
```
1. Citizen submits complaint via API Gateway
2. Gateway validates JWT and routes to Complaint Service
3. Complaint Service validates data and saves to database
4. Service triggers notification to Notification Service
5. Auto-assignment based on category to Department Service
6. Email notification sent to citizen and assigned staff
```

### Status Update Flow
```
1. Staff updates complaint status
2. Complaint Service updates database
3. Status history record created
4. Notification Service triggered
5. Email sent to citizen about status change
6. Dashboard updates reflect new status
```

## 🚀 Deployment Strategy

### Local Development
```bash
# Option 1: Docker Compose (Recommended)
./quick-start.sh

# Option 2: Manual Service Start
./build-all.sh
# Start services individually
```

### Production Deployment
```
┌─────────────────┐
│  Load Balancer  │
│  (nginx/ALB)    │
└─────────────────┘
         │
    ┌────┴────┐
    ▼         ▼
┌─────────┐ ┌─────────┐
│Gateway  │ │Gateway  │
│Instance1│ │Instance2│
└─────────┘ └─────────┘
         │
    ┌────┴────┐
    ▼         ▼
┌─────────┐ ┌─────────┐
│Service  │ │Service  │
│Pool 1   │ │Pool 2   │
└─────────┘ └─────────┘
```

## 📈 Monitoring & Observability

### Health Checks
- **Actuator Endpoints**: `/actuator/health` on all services
- **Service Discovery**: Eureka dashboard shows service status
- **Application Metrics**: Available via `/actuator/metrics`

### Logging Strategy
```
┌─────────────────┐
│  Centralized    │
│  Logging        │
│  (ELK Stack)    │
└─────────────────┘
         ▲
         │
┌─────────────────┐
│  Log Aggregator │
│  (Logstash)     │
└─────────────────┘
         ▲
         │
┌─────────────────┐
│  Service Logs   │
│  (JSON Format)  │
└─────────────────┘
```

## 🔧 Configuration Management

### Centralized Configuration
```
Config Server (:8888)
├── application.yml (common config)
├── user-service.yml
├── complaint-service.yml
├── department-service.yml
├── notification-service.yml
└── api-gateway.yml
```

### Environment-Specific Configs
- **Default Profile**: Local development
- **Docker Profile**: Container deployment
- **Production Profile**: Production optimizations

## 📋 API Documentation

### Core Endpoints
```
Authentication:
POST /api/users/auth/login
POST /api/users/auth/register

User Management:
GET    /api/users
GET    /api/users/{id}
PUT    /api/users/{id}
DELETE /api/users/{id}

Complaint Management:
GET    /api/complaints
POST   /api/complaints
GET    /api/complaints/{id}
PUT    /api/complaints/{id}
POST   /api/complaints/{id}/comments

Department Management:
GET    /api/departments
POST   /api/departments
PUT    /api/departments/{id}
GET    /api/departments/{id}/staff
```

## 🎯 Future Enhancements

### Phase 2 Features
- **Real-time Notifications**: WebSocket integration
- **Mobile App**: React Native or Flutter app
- **Analytics Dashboard**: Complaint trends and metrics
- **GIS Integration**: Location-based complaint mapping
- **Workflow Engine**: Configurable approval workflows

### Technical Improvements
- **Caching Layer**: Redis for session and data caching
- **Message Queue**: RabbitMQ for async processing
- **API Versioning**: Support for multiple API versions
- **Advanced Security**: OAuth2 and SSO integration
- **Microservice Mesh**: Service mesh with Istio

## 🐛 Troubleshooting Guide

### Common Issues

1. **Service Registration Issues**
   ```bash
   # Check Eureka dashboard
   curl http://localhost:8761
   
   # Verify service health
   curl http://localhost:8081/actuator/health
   ```

2. **Database Connection Problems**
   ```bash
   # Check MySQL container
   docker logs mysql-complaint-system
   
   # Test connection
   mysql -h localhost -u root -p complaint_system
   ```

3. **JWT Authentication Errors**
   ```bash
   # Verify token format
   curl -H "Authorization: Bearer <token>" http://localhost:8080/api/users
   
   # Check token expiration
   # JWT tokens expire after 24 hours by default
   ```

### Performance Optimization

1. **Database Optimization**
   - Index frequently queried columns
   - Use connection pooling
   - Implement read replicas for scaling

2. **Application Optimization**
   - Enable response compression
   - Implement caching strategies
   - Use async processing for notifications

3. **Infrastructure Optimization**
   - Use container orchestration (Kubernetes)
   - Implement horizontal pod autoscaling
   - Use managed database services

## 📞 Support & Maintenance

### Monitoring Checklist
- [ ] All services registered in Eureka
- [ ] Database connections healthy
- [ ] JWT tokens generating properly
- [ ] Email notifications working
- [ ] API response times < 200ms
- [ ] No error logs in application logs

### Backup Strategy
- **Database**: Daily automated backups
- **Configuration**: Version controlled in Git
- **Application Logs**: Retained for 30 days
- **Audit Trails**: Permanent retention

This architecture provides a solid foundation for a municipal complaint management system with room for growth and enhancement as requirements evolve.