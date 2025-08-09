#!/bin/bash

# Quick start script for Municipal Complaint Management System

echo "🏛️  Municipal Complaint Management System - Quick Start"
echo "=================================================="

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Check if Docker Compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed."
    exit 1
fi

echo "✅ Docker and Docker Compose are available."

# Build all services
echo ""
echo "🔨 Building all microservices..."
./build-all.sh

if [ $? -eq 0 ]; then
    echo "✅ All services built successfully!"
else
    echo "❌ Build failed. Please check the errors above."
    exit 1
fi

# Start the system
echo ""
echo "🚀 Starting the Municipal Complaint Management System..."
docker-compose up -d

# Wait for services to start
echo ""
echo "⏳ Waiting for services to start..."
sleep 30

# Check service status
echo ""
echo "📊 Service Status:"
echo "=================="

services=("eureka-server:8761" "config-server:8888" "api-gateway:8080" "user-service:8081" "complaint-service:8082" "department-service:8083" "notification-service:8084")

for service in "${services[@]}"; do
    IFS=':' read -r name port <<< "$service"
    if curl -f -s "http://localhost:$port/actuator/health" > /dev/null 2>&1; then
        echo "✅ $name - Running on port $port"
    else
        echo "❌ $name - Not responding on port $port"
    fi
done

echo ""
echo "🌐 Access Points:"
echo "================="
echo "📋 Eureka Dashboard: http://localhost:8761"
echo "🚪 API Gateway: http://localhost:8080"
echo "📖 System Documentation: See README.md"

echo ""
echo "👥 Default Users:"
echo "================"
echo "🔑 Admin: admin / admin123"
echo "🔑 Staff: staff.water / admin123" 
echo "🔑 Citizen: john.doe / citizen123"

echo ""
echo "🧪 Quick API Test:"
echo "=================="
echo "curl -X POST http://localhost:8080/api/users/auth/login \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  -d '{\"username\":\"admin\",\"password\":\"admin123\"}'"

echo ""
echo "🎉 System is ready! Check the services above and refer to README.md for detailed usage."

# Show logs option
echo ""
read -p "Would you like to see the logs? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    docker-compose logs -f
fi