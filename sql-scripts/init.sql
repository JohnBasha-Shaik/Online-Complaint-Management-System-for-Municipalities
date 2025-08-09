-- Create database and use it
CREATE DATABASE IF NOT EXISTS complaint_system;
USE complaint_system;

-- Users table for User Service
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    role ENUM('CITIZEN', 'MUNICIPAL_STAFF', 'ADMIN') NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    enabled BOOLEAN DEFAULT TRUE
);

-- Departments table for Department Service
CREATE TABLE departments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    head_of_department VARCHAR(255),
    contact_email VARCHAR(255),
    contact_phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Department Staff mapping
CREATE TABLE department_staff (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    department_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_department_staff (department_id, user_id)
);

-- Complaints table for Complaint Service
CREATE TABLE complaints (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    category ENUM('WATER', 'SANITATION', 'ROADS', 'ELECTRICITY', 'WASTE_MANAGEMENT', 'OTHER') NOT NULL,
    status ENUM('SUBMITTED', 'IN_PROGRESS', 'RESOLVED', 'REJECTED', 'CLOSED') DEFAULT 'SUBMITTED',
    priority ENUM('LOW', 'MEDIUM', 'HIGH', 'URGENT') DEFAULT 'MEDIUM',
    citizen_id BIGINT NOT NULL,
    assigned_department_id BIGINT,
    assigned_staff_id BIGINT,
    location VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP NULL,
    FOREIGN KEY (citizen_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_department_id) REFERENCES departments(id) ON DELETE SET NULL,
    FOREIGN KEY (assigned_staff_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Complaint Comments for tracking conversation
CREATE TABLE complaint_comments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    complaint_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    comment TEXT NOT NULL,
    comment_type ENUM('CITIZEN_COMMENT', 'STAFF_UPDATE', 'STATUS_CHANGE', 'INTERNAL_NOTE') DEFAULT 'CITIZEN_COMMENT',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (complaint_id) REFERENCES complaints(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Complaint Status History
CREATE TABLE complaint_status_history (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    complaint_id BIGINT NOT NULL,
    old_status VARCHAR(50),
    new_status VARCHAR(50) NOT NULL,
    changed_by BIGINT NOT NULL,
    change_reason TEXT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (complaint_id) REFERENCES complaints(id) ON DELETE CASCADE,
    FOREIGN KEY (changed_by) REFERENCES users(id) ON DELETE CASCADE
);

-- Notifications table for Notification Service
CREATE TABLE notifications (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    complaint_id BIGINT,
    type ENUM('EMAIL', 'SMS', 'IN_APP') NOT NULL,
    subject VARCHAR(255),
    message TEXT NOT NULL,
    status ENUM('PENDING', 'SENT', 'FAILED') DEFAULT 'PENDING',
    sent_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (complaint_id) REFERENCES complaints(id) ON DELETE CASCADE
);

-- Insert default departments
INSERT INTO departments (name, description, contact_email) VALUES
('Water Works', 'Handles water supply, quality, and distribution issues', 'water@municipality.gov'),
('Sanitation Department', 'Manages waste collection, sewage, and cleanliness', 'sanitation@municipality.gov'),
('Road Maintenance', 'Responsible for road repairs, traffic, and infrastructure', 'roads@municipality.gov'),
('Electricity Department', 'Handles power supply and electrical infrastructure', 'electricity@municipality.gov'),
('General Administration', 'Handles other municipal services and general queries', 'admin@municipality.gov');

-- Insert default admin user (password: admin123)
INSERT INTO users (username, email, password, name, role, phone) VALUES
('admin', 'admin@municipality.gov', '$2a$10$8R1M5Y6XJ3.YgQH9Q8ZY2.RJ3M7YH9WQY3M8J5Y6XJ3.YgQH9Q8ZY2e', 'System Administrator', 'ADMIN', '1234567890');

-- Insert sample municipal staff
INSERT INTO users (username, email, password, name, role, phone) VALUES
('staff.water', 'water.staff@municipality.gov', '$2a$10$8R1M5Y6XJ3.YgQH9Q8ZY2.RJ3M7YH9WQY3M8J5Y6XJ3.YgQH9Q8ZY2e', 'Water Department Staff', 'MUNICIPAL_STAFF', '1234567891'),
('staff.sanitation', 'sanitation.staff@municipality.gov', '$2a$10$8R1M5Y6XJ3.YgQH9Q8ZY2.RJ3M7YH9WQY3M8J5Y6XJ3.YgQH9Q8ZY2e', 'Sanitation Department Staff', 'MUNICIPAL_STAFF', '1234567892'),
('staff.roads', 'roads.staff@municipality.gov', '$2a$10$8R1M5Y6XJ3.YgQH9Q8ZY2.RJ3M7YH9WQY3M8J5Y6XJ3.YgQH9Q8ZY2e', 'Road Maintenance Staff', 'MUNICIPAL_STAFF', '1234567893');

-- Assign staff to departments
INSERT INTO department_staff (department_id, user_id) VALUES
(1, 2), -- Water staff to Water Works
(2, 3), -- Sanitation staff to Sanitation Department  
(3, 4); -- Road staff to Road Maintenance

-- Insert sample citizen user (password: citizen123)
INSERT INTO users (username, email, password, name, role, phone, address) VALUES
('john.doe', 'john.doe@email.com', '$2a$10$8R1M5Y6XJ3.YgQH9Q8ZY2.RJ3M7YH9WQY3M8J5Y6XJ3.YgQH9Q8ZY2e', 'John Doe', 'CITIZEN', '9876543210', '123 Main Street, Cityville');