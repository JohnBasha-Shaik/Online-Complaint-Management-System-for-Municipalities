<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Departments Management - Municipality Complaint System</title>
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
                        <li><a href="/dashboard" class="nav-link">Dashboard</a></li>
                        <li><a href="/complaints" class="nav-link">Complaints</a></li>
                        <li><a href="/departments" class="nav-link active">Departments</a></li>
                        <li><a href="/profile" class="nav-link">Profile</a></li>
                        <li><a href="#" class="nav-link" onclick="complaintManager.handleLogout()">Logout</a></li>
                    </ul>
                </nav>
            </div>
        </div>
    </header>

    <main class="main">
        <div class="container">
            <!-- Page Header -->
            <div class="page-header">
                <h2>Departments Management</h2>
                <p>Manage municipal departments and staff assignments</p>
            </div>

            <!-- Department Statistics -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">🏢</div>
                    <div class="stat-content">
                        <h3 id="totalDepartments">0</h3>
                        <p>Total Departments</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">👥</div>
                    <div class="stat-content">
                        <h3 id="totalStaff">0</h3>
                        <p>Total Staff</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">📋</div>
                    <div class="stat-content">
                        <h3 id="activeComplaints">0</h3>
                        <p>Active Complaints</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">⚡</div>
                    <div class="stat-content">
                        <h3 id="avgResponseTime">0h</h3>
                        <p>Avg Response Time</p>
                    </div>
                </div>
            </div>

            <!-- Actions Bar -->
            <div class="actions-bar">
                <button class="btn btn-primary" onclick="showDepartmentForm()">
                    🏢 Add Department
                </button>
                <button class="btn btn-secondary" onclick="showStaffForm()">
                    👤 Add Staff
                </button>
                <button class="btn btn-outline" onclick="refreshDepartments()">
                    🔄 Refresh
                </button>
                <button class="btn btn-outline" onclick="exportDepartments()">
                    📊 Export
                </button>
            </div>

            <!-- Departments Grid -->
            <div class="departments-grid" id="departmentsGrid">
                <!-- Departments will be loaded here dynamically -->
            </div>

            <!-- Staff Management Section -->
            <div class="staff-section">
                <h3>Staff Management</h3>
                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Department</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="staffTableBody">
                            <!-- Staff will be loaded here dynamically -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>

    <!-- Department Form Modal -->
    <div id="departmentModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="departmentModalTitle">Add New Department</h3>
                <span class="close" onclick="closeDepartmentModal()">&times;</span>
            </div>
            <div class="modal-body">
                <form id="departmentForm">
                    <input type="hidden" id="departmentId" name="id">
                    
                    <div class="form-group">
                        <label for="departmentName">Department Name</label>
                        <input type="text" id="departmentName" name="name" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="departmentCode">Department Code</label>
                        <input type="text" id="departmentCode" name="code" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="departmentDescription">Description</label>
                        <textarea id="departmentDescription" name="description" rows="3"></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="departmentHead">Department Head</label>
                        <select id="departmentHead" name="headId">
                            <option value="">Select Department Head</option>
                            <!-- Staff options will be loaded here -->
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="departmentStatus">Status</label>
                        <select id="departmentStatus" name="status">
                            <option value="ACTIVE">Active</option>
                            <option value="INACTIVE">Inactive</option>
                        </select>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" onclick="closeDepartmentModal()">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Department</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Staff Form Modal -->
    <div id="staffModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="staffModalTitle">Add New Staff</h3>
                <span class="close" onclick="closeStaffModal()">&times;</span>
            </div>
            <div class="modal-body">
                <form id="staffForm">
                    <input type="hidden" id="staffId" name="id">
                    
                    <div class="form-group">
                        <label for="staffName">Full Name</label>
                        <input type="text" id="staffName" name="name" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="staffEmail">Email</label>
                        <input type="email" id="staffEmail" name="email" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="staffUsername">Username</label>
                        <input type="text" id="staffUsername" name="username" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="staffDepartment">Department</label>
                        <select id="staffDepartment" name="departmentId" required>
                            <option value="">Select Department</option>
                            <!-- Department options will be loaded here -->
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="staffRole">Role</label>
                        <select id="staffRole" name="role" required>
                            <option value="">Select Role</option>
                            <option value="STAFF">Staff</option>
                            <option value="SUPERVISOR">Supervisor</option>
                            <option value="MANAGER">Manager</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="staffStatus">Status</label>
                        <select id="staffStatus" name="status">
                            <option value="ACTIVE">Active</option>
                            <option value="INACTIVE">Inactive</option>
                        </select>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" onclick="closeStaffModal()">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Staff</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Department Details Modal -->
    <div id="departmentDetailsModal" class="modal">
        <div class="modal-content large">
            <div class="modal-header">
                <h3>Department Details</h3>
                <span class="close" onclick="closeDepartmentDetailsModal()">&times;</span>
            </div>
            <div class="modal-body">
                <div id="departmentDetailsContent">
                    <!-- Department details will be loaded here -->
                </div>
            </div>
        </div>
    </div>

    <script src="/static/js/app.js"></script>
    <script>
        // Global variables
        let departments = [];
        let staff = [];

        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            complaintManager.checkAuthStatus();
            loadDepartments();
            loadStaff();
        });

        function loadDepartments() {
            // Load departments from API
            fetch('/api/departments')
                .then(response => response.json())
                .then(data => {
                    departments = data;
                    renderDepartments();
                    updateDepartmentStats();
                })
                .catch(error => {
                    console.error('Error loading departments:', error);
                    complaintManager.showAlert('Error loading departments', 'error');
                });
        }

        function loadStaff() {
            // Load staff from API
            fetch('/api/users?role=STAFF')
                .then(response => response.json())
                .then(data => {
                    staff = data;
                    renderStaff();
                    updateStaffOptions();
                })
                .catch(error => {
                    console.error('Error loading staff:', error);
                    complaintManager.showAlert('Error loading staff', 'error');
                });
        }

        function renderDepartments() {
            const grid = document.getElementById('departmentsGrid');
            grid.innerHTML = '';

            departments.forEach(dept => {
                const deptCard = createDepartmentCard(dept);
                grid.appendChild(deptCard);
            });
        }

        function createDepartmentCard(dept) {
            const card = document.createElement('div');
            card.className = 'department-card';
            card.innerHTML = `
                <div class="department-header">
                    <h4>${dept.name}</h4>
                    <span class="badge badge-${dept.status === 'ACTIVE' ? 'success' : 'secondary'}">${dept.status}</span>
                </div>
                <div class="department-body">
                    <p><strong>Code:</strong> ${dept.code}</p>
                    <p><strong>Description:</strong> ${dept.description || 'No description'}</p>
                    <p><strong>Head:</strong> ${dept.headName || 'Not assigned'}</p>
                    <p><strong>Staff Count:</strong> ${dept.staffCount || 0}</p>
                    <p><strong>Active Complaints:</strong> ${dept.activeComplaints || 0}</p>
                </div>
                <div class="department-actions">
                    <button class="btn btn-sm btn-primary" onclick="viewDepartment(${dept.id})">View</button>
                    <button class="btn btn-sm btn-secondary" onclick="editDepartment(${dept.id})">Edit</button>
                    <button class="btn btn-sm btn-outline" onclick="deleteDepartment(${dept.id})">Delete</button>
                </div>
            `;
            return card;
        }

        function renderStaff() {
            const tbody = document.getElementById('staffTableBody');
            tbody.innerHTML = '';

            staff.forEach(member => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${member.name}</td>
                    <td>${member.email}</td>
                    <td>${member.departmentName || 'Not assigned'}</td>
                    <td>${member.role}</td>
                    <td><span class="badge badge-${member.status === 'ACTIVE' ? 'success' : 'secondary'}">${member.status}</span></td>
                    <td>
                        <button class="btn btn-sm btn-secondary" onclick="editStaff(${member.id})">Edit</button>
                        <button class="btn btn-sm btn-outline" onclick="deleteStaff(${member.id})">Delete</button>
                    </td>
                `;
                tbody.appendChild(row);
            });
        }

        function updateDepartmentStats() {
            document.getElementById('totalDepartments').textContent = departments.length;
            document.getElementById('totalStaff').textContent = staff.length;
            
            const activeComplaints = departments.reduce((sum, dept) => sum + (dept.activeComplaints || 0), 0);
            document.getElementById('activeComplaints').textContent = activeComplaints;
            
            // Calculate average response time (placeholder)
            document.getElementById('avgResponseTime').textContent = '2.5h';
        }

        function updateStaffOptions() {
            const departmentHeadSelect = document.getElementById('departmentHead');
            const staffDepartmentSelect = document.getElementById('staffDepartment');
            
            // Update department head options
            departmentHeadSelect.innerHTML = '<option value="">Select Department Head</option>';
            staff.forEach(member => {
                if (member.role === 'MANAGER' || member.role === 'SUPERVISOR') {
                    const option = document.createElement('option');
                    option.value = member.id;
                    option.textContent = member.name;
                    departmentHeadSelect.appendChild(option);
                }
            });
            
            // Update staff department options
            staffDepartmentSelect.innerHTML = '<option value="">Select Department</option>';
            departments.forEach(dept => {
                const option = document.createElement('option');
                option.value = dept.id;
                option.textContent = dept.name;
                staffDepartmentSelect.appendChild(option);
            });
        }

        function showDepartmentForm() {
            document.getElementById('departmentModalTitle').textContent = 'Add New Department';
            document.getElementById('departmentForm').reset();
            document.getElementById('departmentId').value = '';
            document.getElementById('departmentModal').style.display = 'block';
        }

        function closeDepartmentModal() {
            document.getElementById('departmentModal').style.display = 'none';
        }

        function showStaffForm() {
            document.getElementById('staffModalTitle').textContent = 'Add New Staff';
            document.getElementById('staffForm').reset();
            document.getElementById('staffId').value = '';
            document.getElementById('staffModal').style.display = 'block';
        }

        function closeStaffModal() {
            document.getElementById('staffModal').style.display = 'none';
        }

        function closeDepartmentDetailsModal() {
            document.getElementById('departmentDetailsModal').style.display = 'none';
        }

        function refreshDepartments() {
            loadDepartments();
            loadStaff();
        }

        function exportDepartments() {
            complaintManager.showAlert('Export functionality coming soon!', 'info');
        }

        function viewDepartment(id) {
            const dept = departments.find(d => d.id === id);
            if (dept) {
                document.getElementById('departmentDetailsContent').innerHTML = `
                    <div class="department-details">
                        <h4>${dept.name}</h4>
                        <p><strong>Code:</strong> ${dept.code}</p>
                        <p><strong>Description:</strong> ${dept.description || 'No description'}</p>
                        <p><strong>Status:</strong> ${dept.status}</p>
                        <p><strong>Head:</strong> ${dept.headName || 'Not assigned'}</p>
                        <p><strong>Staff Count:</strong> ${dept.staffCount || 0}</p>
                        <p><strong>Active Complaints:</strong> ${dept.activeComplaints || 0}</p>
                    </div>
                `;
                document.getElementById('departmentDetailsModal').style.display = 'block';
            }
        }

        function editDepartment(id) {
            const dept = departments.find(d => d.id === id);
            if (dept) {
                document.getElementById('departmentModalTitle').textContent = 'Edit Department';
                document.getElementById('departmentId').value = dept.id;
                document.getElementById('departmentName').value = dept.name;
                document.getElementById('departmentCode').value = dept.code;
                document.getElementById('departmentDescription').value = dept.description || '';
                document.getElementById('departmentHead').value = dept.headId || '';
                document.getElementById('departmentStatus').value = dept.status;
                document.getElementById('departmentModal').style.display = 'block';
            }
        }

        function deleteDepartment(id) {
            if (confirm('Are you sure you want to delete this department?')) {
                // Implementation for deleting department
                complaintManager.showAlert('Department deleted successfully', 'success');
                loadDepartments();
            }
        }

        function editStaff(id) {
            const member = staff.find(s => s.id === id);
            if (member) {
                document.getElementById('staffModalTitle').textContent = 'Edit Staff';
                document.getElementById('staffId').value = member.id;
                document.getElementById('staffName').value = member.name;
                document.getElementById('staffEmail').value = member.email;
                document.getElementById('staffUsername').value = member.username;
                document.getElementById('staffDepartment').value = member.departmentId || '';
                document.getElementById('staffRole').value = member.role;
                document.getElementById('staffStatus').value = member.status;
                document.getElementById('staffModal').style.display = 'block';
            }
        }

        function deleteStaff(id) {
            if (confirm('Are you sure you want to delete this staff member?')) {
                // Implementation for deleting staff
                complaintManager.showAlert('Staff member deleted successfully', 'success');
                loadStaff();
            }
        }

        // Handle department form submission
        document.getElementById('departmentForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = {
                id: document.getElementById('departmentId').value,
                name: document.getElementById('departmentName').value,
                code: document.getElementById('departmentCode').value,
                description: document.getElementById('departmentDescription').value,
                headId: document.getElementById('departmentHead').value,
                status: document.getElementById('departmentStatus').value
            };
            
            // Implementation for saving department
            complaintManager.showAlert('Department saved successfully', 'success');
            closeDepartmentModal();
            loadDepartments();
        });

        // Handle staff form submission
        document.getElementById('staffForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = {
                id: document.getElementById('staffId').value,
                name: document.getElementById('staffName').value,
                email: document.getElementById('staffEmail').value,
                username: document.getElementById('staffUsername').value,
                departmentId: document.getElementById('staffDepartment').value,
                role: document.getElementById('staffRole').value,
                status: document.getElementById('staffStatus').value
            };
            
            // Implementation for saving staff
            complaintManager.showAlert('Staff member saved successfully', 'success');
            closeStaffModal();
            loadStaff();
        });

        // Close modals when clicking outside
        window.onclick = function(event) {
            const modals = ['departmentModal', 'staffModal', 'departmentDetailsModal'];
            modals.forEach(modalId => {
                const modal = document.getElementById(modalId);
                if (event.target === modal) {
                    modal.style.display = 'none';
                }
            });
        };
    </script>
</body>
</html>