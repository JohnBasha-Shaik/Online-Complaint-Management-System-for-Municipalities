#!/bin/bash

# Build script for all microservices

echo "Building Municipal Complaint Management System..."

# Build parent project
echo "Building parent project..."
mvn clean compile -DskipTests

# Build individual services
echo "Building Eureka Server..."
cd eureka-server && mvn clean package -DskipTests && cd ..

echo "Building Config Server..."
cd config-server && mvn clean package -DskipTests && cd ..

echo "Building API Gateway..."
cd api-gateway && mvn clean package -DskipTests && cd ..

echo "Building User Service..."
cd user-service && mvn clean package -DskipTests && cd ..

echo "Building Complaint Service..."
cd complaint-service && mvn clean package -DskipTests && cd ..

echo "Building Department Service..."
cd department-service && mvn clean package -DskipTests && cd ..

echo "Building Notification Service..."
cd notification-service && mvn clean package -DskipTests && cd ..

echo "All services built successfully!"
echo "You can now run: docker-compose up -d"