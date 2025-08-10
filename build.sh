#!/bin/bash

echo "🏗️  Building Municipal Complaint Management System"
echo "================================================"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
echo "📋 Checking prerequisites..."

if ! command_exists java; then
    echo "❌ Java is not installed. Please install Java 17 or higher."
    exit 1
fi

if ! command_exists mvn; then
    echo "❌ Maven is not installed. Please install Maven 3.6+."
    exit 1
fi

if ! command_exists docker; then
    echo "❌ Docker is not installed. Please install Docker."
    exit 1
fi

if ! command_exists docker-compose; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose."
    exit 1
fi

echo "✅ All prerequisites are met!"

# Clean previous builds
echo "🧹 Cleaning previous builds..."
mvn clean

# Build all services
echo "🔨 Building all microservices..."
mvn package -DskipTests

if [ $? -ne 0 ]; then
    echo "❌ Build failed. Please check the logs above."
    exit 1
fi

echo "✅ All services built successfully!"

# Start services with Docker Compose
echo "🚀 Starting services with Docker Compose..."
docker-compose up -d

if [ $? -ne 0 ]; then
    echo "❌ Failed to start services. Please check Docker Compose logs."
    exit 1
fi

echo "✅ All services are starting up!"

# Wait for services to be healthy
echo "⏳ Waiting for services to be ready..."
sleep 30

# Check service health
echo "🔍 Checking service health..."

services=("eureka-server:8761" "config-server:8888" "api-gateway:8080" "user-service:8081" "complaint-service:8082" "department-service:8083" "notification-service:8084")

for service in "${services[@]}"; do
    name=$(echo $service | cut -d':' -f1)
    port=$(echo $service | cut -d':' -f2)
    
    if curl -f http://localhost:$port/actuator/health > /dev/null 2>&1; then
        echo "✅ $name is healthy"
    else
        echo "⚠️  $name is not yet ready (may still be starting up)"
    fi
done

echo ""
echo "🎉 Municipal Complaint Management System Setup Complete!"
echo "======================================================="
echo ""
echo "📊 Service URLs:"
echo "• Eureka Dashboard: http://localhost:8761"
echo "• API Gateway: http://localhost:8080"
echo "• Config Server: http://localhost:8888"
echo ""
echo "📚 API Documentation:"
echo "• User Service: http://localhost:8080/api/users/"
echo "• Complaint Service: http://localhost:8080/api/complaints/"
echo "• Department Service: http://localhost:8080/api/departments/"
echo "• Notification Service: http://localhost:8080/api/notifications/"
echo ""
echo "🔐 Default Database:"
echo "• Host: localhost:3306"
echo "• Username: root"
echo "• Password: password"
echo ""
echo "📖 For detailed documentation, see README.md"
echo "🚀 System is ready for use!"