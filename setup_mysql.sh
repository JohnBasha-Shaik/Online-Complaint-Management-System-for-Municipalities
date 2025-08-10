#!/bin/bash

# Municipality Complaint System - MySQL Setup Script
# This script automates the MySQL database setup for all microservices

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
MYSQL_ROOT_PASSWORD=""
MYSQL_USER="municipality_user"
MYSQL_PASSWORD="municipality_password"
MYSQL_HOST="localhost"
MYSQL_PORT="3306"

# Database names
DATABASES=("user_service" "complaint_service" "department_service" "notification_service")

echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}  Municipality Complaint System${NC}"
echo -e "${BLUE}      MySQL Setup Script      ${NC}"
echo -e "${BLUE}================================${NC}"
echo ""

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if MySQL is running
check_mysql_running() {
    if systemctl is-active --quiet mysql 2>/dev/null || systemctl is-active --quiet mysqld 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to check if MySQL command is available
check_mysql_command() {
    if command -v mysql &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to install MySQL
install_mysql() {
    print_status "Installing MySQL..."
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt-get &> /dev/null; then
            # Ubuntu/Debian
            sudo apt-get update
            sudo apt-get install -y mysql-server
            sudo systemctl start mysql
            sudo systemctl enable mysql
        elif command -v yum &> /dev/null; then
            # CentOS/RHEL
            sudo yum install -y mysql-server
            sudo systemctl start mysqld
            sudo systemctl enable mysqld
        else
            print_error "Unsupported Linux distribution. Please install MySQL manually."
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install mysql
            brew services start mysql
        else
            print_error "Homebrew not found. Please install MySQL manually."
            exit 1
        fi
    else
        print_error "Unsupported operating system. Please install MySQL manually."
        exit 1
    fi
    
    print_status "MySQL installation completed."
}

# Function to secure MySQL installation
secure_mysql() {
    print_status "Securing MySQL installation..."
    
    # Check if MySQL is running
    if ! check_mysql_running; then
        print_error "MySQL is not running. Please start MySQL first."
        exit 1
    fi
    
    # Try to run mysql_secure_installation
    if command -v mysql_secure_installation &> /dev/null; then
        print_warning "Running mysql_secure_installation..."
        print_warning "Please follow the prompts to secure your MySQL installation."
        print_warning "Recommended settings:"
        print_warning "  - Set root password: Yes"
        print_warning "  - Remove anonymous users: Yes"
        print_warning "  - Disallow root login remotely: Yes"
        print_warning "  - Remove test database: Yes"
        print_warning "  - Reload privilege tables: Yes"
        echo ""
        sudo mysql_secure_installation
    else
        print_warning "mysql_secure_installation not found. Please secure MySQL manually."
    fi
}

# Function to create MySQL user and databases
setup_databases() {
    print_status "Setting up MySQL user and databases..."
    
    # Prompt for root password
    echo -n "Enter MySQL root password: "
    read -s MYSQL_ROOT_PASSWORD
    echo ""
    
    # Create MySQL user and databases
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" << EOF
-- Create dedicated user
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'$MYSQL_HOST' IDENTIFIED BY '$MYSQL_PASSWORD';

-- Grant permissions to all databases
$(for db in "${DATABASES[@]}"; do
    echo "GRANT ALL PRIVILEGES ON $db.* TO '$MYSQL_USER'@'$MYSQL_HOST';"
done)

-- Grant permission to create databases
GRANT CREATE ON *.* TO '$MYSQL_USER'@'$MYSQL_HOST';

FLUSH PRIVILEGES;
EOF
    
    print_status "MySQL user and databases setup completed."
}

# Function to create database schema
create_schema() {
    print_status "Creating database schema..."
    
    # Create schema for each database
    for db in "${DATABASES[@]}"; do
        print_status "Setting up schema for $db..."
        
        case $db in
            "user_service")
                mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" << EOF
USE $db;

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
EOF
                ;;
                
            "complaint_service")
                mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" << EOF
USE $db;

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
EOF
                ;;
                
            "department_service")
                mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" << EOF
USE $db;

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
EOF
                ;;
                
            "notification_service")
                mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" << EOF
USE $db;

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
EOF
                ;;
        esac
        
        print_status "Schema created for $db"
    done
    
    print_status "Database schema creation completed."
}

# Function to insert sample data
insert_sample_data() {
    print_status "Inserting sample data..."
    
    # Insert sample data into user_service
    mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" << EOF
USE user_service;

-- Insert sample departments
INSERT IGNORE INTO departments (id, name, description) VALUES
(1, 'Water Works', 'Manages water supply and maintenance'),
(2, 'Sanitation', 'Handles waste management and cleaning'),
(3, 'Roads Maintenance', 'Road repairs and maintenance'),
(4, 'Electrical', 'Street lighting and electrical issues'),
(5, 'General', 'General municipal services');

-- Insert sample admin user (password: admin123)
INSERT IGNORE INTO users (id, username, email, password, name, role, status) VALUES
(1, 'admin', 'admin@municipality.com', '\$2a\$10\$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'System Administrator', 'ADMIN', 'ACTIVE');

-- Insert sample staff users
INSERT IGNORE INTO users (id, username, email, password, name, role, department_id, status) VALUES
(2, 'manager1', 'manager1@municipality.com', '\$2a\$10\$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'John Manager', 'MANAGER', 1, 'ACTIVE'),
(3, 'staff1', 'staff1@municipality.com', '\$2a\$10\$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'Jane Staff', 'STAFF', 1, 'ACTIVE');

-- Insert sample citizen
INSERT IGNORE INTO users (id, username, email, password, name, role, status) VALUES
(4, 'citizen1', 'citizen1@example.com', '\$2a\$10\$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'John Citizen', 'CITIZEN', 'ACTIVE');
EOF

    # Insert sample data into complaint_service
    mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" << EOF
USE complaint_service;

-- Insert sample complaints
INSERT IGNORE INTO complaints (id, title, description, category, priority, citizen_id, status) VALUES
(1, 'Water Supply Issue', 'No water supply in my area for the past 2 days', 'WATER', 'HIGH', 4, 'SUBMITTED'),
(2, 'Road Pothole', 'Large pothole on Main Street causing traffic issues', 'ROADS', 'MEDIUM', 4, 'SUBMITTED');
EOF

    # Insert sample data into department_service
    mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" << EOF
USE department_service;

-- Insert sample departments
INSERT IGNORE INTO departments (id, name, description) VALUES
(1, 'Water Works', 'Manages water supply and maintenance'),
(2, 'Sanitation', 'Handles waste management and cleaning'),
(3, 'Roads Maintenance', 'Road repairs and maintenance'),
(4, 'Electrical', 'Street lighting and electrical issues'),
(5, 'General', 'General municipal services');

-- Insert sample staff
INSERT IGNORE INTO staff (id, user_id, department_id, position, hire_date) VALUES
(1, 2, 1, 'Department Manager', '2023-01-15'),
(2, 3, 1, 'Field Staff', '2023-02-01');
EOF

    # Insert sample data into notification_service
    mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" << EOF
USE notification_service;

-- Insert sample notification templates
INSERT IGNORE INTO notification_templates (id, name, type, subject, body) VALUES
(1, 'Complaint Submitted', 'EMAIL', 'Complaint Submitted Successfully', 'Dear {{citizenName}}, Your complaint regarding {{issue}} has been submitted successfully. Complaint ID: {{complaintId}}'),
(2, 'Complaint Status Update', 'EMAIL', 'Complaint Status Updated', 'Dear {{citizenName}}, Your complaint (ID: {{complaintId}}) status has been updated to {{status}}');
EOF
    
    print_status "Sample data insertion completed."
}

# Function to verify setup
verify_setup() {
    print_status "Verifying MySQL setup..."
    
    # Test connection to each database
    for db in "${DATABASES[@]}"; do
        if mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "USE $db; SHOW TABLES;" &> /dev/null; then
            print_status "✓ Database $db is accessible"
        else
            print_error "✗ Database $db is not accessible"
        fi
    done
    
    # Show database summary
    echo ""
    print_status "Database Summary:"
    mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "
SELECT 
    table_schema as 'Database',
    COUNT(*) as 'Tables'
FROM information_schema.tables 
WHERE table_schema IN ('user_service', 'complaint_service', 'department_service', 'notification_service')
GROUP BY table_schema
ORDER BY table_schema;
"
    
    print_status "MySQL setup verification completed."
}

# Function to show connection details
show_connection_details() {
    echo ""
    print_status "Connection Details:"
    echo "Host: $MYSQL_HOST"
    echo "Port: $MYSQL_PORT"
    echo "Username: $MYSQL_USER"
    echo "Password: $MYSQL_PASSWORD"
    echo ""
    print_status "Sample connection command:"
    echo "mysql -u $MYSQL_USER -p -h $MYSQL_HOST -P $MYSQL_PORT user_service"
    echo ""
}

# Main execution
main() {
    echo -e "${BLUE}Starting MySQL setup for Municipality Complaint System...${NC}"
    echo ""
    
    # Check if MySQL is installed
    if ! check_mysql_command; then
        print_warning "MySQL command not found. Installing MySQL..."
        install_mysql
    else
        print_status "MySQL is already installed."
    fi
    
    # Check if MySQL is running
    if ! check_mysql_running; then
        print_warning "MySQL is not running. Starting MySQL..."
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            if command -v systemctl &> /dev/null; then
                sudo systemctl start mysql 2>/dev/null || sudo systemctl start mysqld
            fi
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            brew services start mysql
        fi
    fi
    
    # Wait a moment for MySQL to fully start
    sleep 3
    
    # Secure MySQL installation
    secure_mysql
    
    # Setup databases
    setup_databases
    
    # Create schema
    create_schema
    
    # Insert sample data
    insert_sample_data
    
    # Verify setup
    verify_setup
    
    # Show connection details
    show_connection_details
    
    echo ""
    print_status "MySQL setup completed successfully!"
    print_status "You can now start your microservices."
    echo ""
    print_status "Next steps:"
    echo "1. Start Config Server: cd config-server && mvn spring-boot:run"
    echo "2. Start Eureka Server: cd eureka-server && mvn spring-boot:run"
    echo "3. Start Microservices: Start each service in order"
    echo ""
    print_status "Default login credentials:"
    echo "Username: admin"
    echo "Password: admin123"
}

# Check if script is run with sudo
if [[ $EUID -eq 0 ]]; then
    print_error "This script should not be run as root. Please run as a regular user."
    exit 1
fi

# Run main function
main "$@"