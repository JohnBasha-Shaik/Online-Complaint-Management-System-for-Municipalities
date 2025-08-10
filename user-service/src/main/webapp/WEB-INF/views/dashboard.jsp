<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Municipality Complaint System</title>
    <link rel="stylesheet" href="/static/css/style.css">
</head>
<body>
    <header class="header">
        <div class="container">
            <div class="header-content">
                <div class="logo">
                    <h1>Municipality Complaint System</h1>
                </div>
                <nav class="nav">
                    <ul class="nav-list">
                        <li><a href="/dashboard" class="nav-link active">Dashboard</a></li>
                        <li><a href="/complaints" class="nav-link">Complaints</a></li>
                        <li><a href="/departments" class="nav-link">Departments</a></li>
                        <li><a href="/profile" class="nav-link">Profile</a></li>
                        <li><a href="#" class="nav-link" onclick="complaintManager.handleLogout()">Logout</a></li>
                    </ul>
                </nav>
            </div>
        </div>
    </header>

    <main class="main">
        <div class="container">
            <!-- Welcome Section -->
            <div class="welcome-section">
                <h2>Welcome, <span id="userName">User</span>!</h2>
                <p>Manage complaints and track their progress</p>
            </div>

            <!-- Statistics Section -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">📊</div>
                    <div class="stat-content">
                        <h3 id="totalComplaints">0</h3>
                        <p>Total Complaints</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">⏳</div>
                    <div class="stat-content">
                        <h3 id="pendingComplaints">0</h3>
                        <p>Pending</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">✅</div>
                    <div class="stat-content">
                        <h3 id="resolvedComplaints">0</h3>
                        <p>Resolved</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">🚧</div>
                    <div class="stat-content">
                        <h3 id="inProgressComplaints">0</h3>
                        <p>In Progress</p>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="quick-actions">
                <h3>Quick Actions</h3>
                <div class="action-buttons">
                    <button class="btn btn-primary" onclick="showComplaintForm()">Submit New Complaint</button>
                    <button class="btn btn-secondary" onclick="refreshDashboard()">Refresh Dashboard</button>
                    <button class="btn btn-outline" onclick="exportData()">Export Data</button>
                </div>
            </div>

            <!-- Recent Complaints -->
            <div class="recent-complaints">
                <div class="section-header">
                    <h3>Recent Complaints</h3>
                    <div class="filters">
                        <select id="statusFilter" onchange="filterComplaints()">
                            <option value="">All Status</option>
                            <option value="PENDING">Pending</option>
                            <option value="IN_PROGRESS">In Progress</option>
                            <option value="RESOLVED">Resolved</option>
                            <option value="CLOSED">Closed</option>
                        </select>
                        <select id="categoryFilter" onchange="filterComplaints()">
                            <option value="">All Categories</option>
                            <option value="WATER">Water</option>
                            <option value="SANITATION">Sanitation</option>
                            <option value="ROADS">Roads</option>
                            <option value="ELECTRICITY">Electricity</option>
                            <option value="OTHER">Other</option>
                        </select>
                    </div>
                </div>
                
                <div id="complaintsList" class="complaints-list">
                    <!-- Complaints will be loaded here dynamically -->
                </div>
            </div>
        </div>
    </main>

    <!-- Complaint Submission Modal -->
    <div id="complaintModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Submit New Complaint</h3>
                <span class="close" onclick="closeComplaintModal()">&times;</span>
            </div>
            <div class="modal-body">
                <form id="complaintForm">
                    <div class="form-group">
                        <label for="complaintCategory">Category</label>
                        <select id="complaintCategory" name="category" required>
                            <option value="">Select Category</option>
                            <option value="WATER">Water Issues</option>
                            <option value="SANITATION">Sanitation</option>
                            <option value="ROADS">Road Problems</option>
                            <option value="ELECTRICITY">Electrical Issues</option>
                            <option value="OTHER">Other</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="complaintDescription">Description</label>
                        <textarea id="complaintDescription" name="description" rows="4" 
                                  placeholder="Please describe the issue in detail..." required></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="complaintLocation">Location (Optional)</label>
                        <input type="text" id="complaintLocation" name="location" 
                               placeholder="Street address or area">
                    </div>
                    
                    <div class="form-group">
                        <label for="complaintPriority">Priority</label>
                        <select id="complaintPriority" name="priority">
                            <option value="LOW">Low</option>
                            <option value="MEDIUM" selected>Medium</option>
                            <option value="HIGH">High</option>
                            <option value="URGENT">Urgent</option>
                        </select>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" onclick="closeComplaintModal()">Cancel</button>
                        <button type="submit" class="btn btn-primary">Submit Complaint</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Complaint Details Modal -->
    <div id="complaintDetailsModal" class="modal">
        <div class="modal-content large">
            <div class="modal-header">
                <h3>Complaint Details</h3>
                <span class="close" onclick="closeComplaintDetailsModal()">&times;</span>
            </div>
            <div class="modal-body">
                <div id="complaintDetailsContent">
                    <!-- Complaint details will be loaded here -->
                </div>
            </div>
        </div>
    </div>

    <script src="/static/js/app.js"></script>
    <script>
        // Global variables
        let currentUser = null;
        let complaints = [];

        // Initialize dashboard
        document.addEventListener('DOMContentLoaded', function() {
            complaintManager.checkAuthStatus();
            loadDashboard();
        });

        function loadDashboard() {
            complaintManager.loadDashboard();
        }

        function refreshDashboard() {
            loadDashboard();
        }

        function showComplaintForm() {
            document.getElementById('complaintModal').style.display = 'block';
        }

        function closeComplaintModal() {
            document.getElementById('complaintModal').style.display = 'none';
            document.getElementById('complaintForm').reset();
        }

        function closeComplaintDetailsModal() {
            document.getElementById('complaintDetailsModal').style.display = 'none';
        }

        function filterComplaints() {
            const statusFilter = document.getElementById('statusFilter').value;
            const categoryFilter = document.getElementById('categoryFilter').value;
            
            complaintManager.filterComplaints(statusFilter, categoryFilter);
        }

        function exportData() {
            // Implementation for exporting complaint data
            complaintManager.showAlert('Export functionality coming soon!', 'info');
        }

        // Handle complaint form submission
        document.getElementById('complaintForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = {
                category: document.getElementById('complaintCategory').value,
                description: document.getElementById('complaintDescription').value,
                location: document.getElementById('complaintLocation').value,
                priority: document.getElementById('complaintPriority').value
            };
            
            complaintManager.handleComplaintSubmit(formData);
            closeComplaintModal();
        });

        // Close modals when clicking outside
        window.onclick = function(event) {
            const complaintModal = document.getElementById('complaintModal');
            const complaintDetailsModal = document.getElementById('complaintDetailsModal');
            
            if (event.target === complaintModal) {
                closeComplaintModal();
            }
            if (event.target === complaintDetailsModal) {
                closeComplaintDetailsModal();
            }
        };
    </script>
</body>
</html>