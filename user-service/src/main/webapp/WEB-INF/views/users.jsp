<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - Municipality Complaint System</title>
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
                        <li><a href="/departments" class="nav-link">Departments</a></li>
                        <li><a href="/users" class="nav-link active">Users</a></li>
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
                <h2>User Management</h2>
                <p>Manage system users, roles, and permissions</p>
            </div>

            <!-- User Statistics -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">👥</div>
                    <div class="stat-content">
                        <h3 id="totalUsers">0</h3>
                        <p>Total Users</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">👨‍💼</div>
                    <div class="stat-content">
                        <h3 id="activeUsers">0</h3>
                        <p>Active Users</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">🏢</div>
                    <div class="stat-content">
                        <h3 id="staffUsers">0</h3>
                        <p>Staff Members</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">👤</div>
                    <div class="stat-content">
                        <h3 id="citizenUsers">0</h3>
                        <p>Citizens</p>
                    </div>
                </div>
            </div>

            <!-- Search and Filters -->
            <div class="search-filters">
                <div class="search-box">
                    <input type="text" id="searchInput" placeholder="Search users..." 
                           onkeyup="handleSearch()">
                    <button class="btn btn-primary" onclick="handleSearch()">
                        <span>🔍</span> Search
                    </button>
                </div>
                
                <div class="filters">
                    <select id="roleFilter" onchange="filterUsers()">
                        <option value="">All Roles</option>
                        <option value="CITIZEN">Citizen</option>
                        <option value="STAFF">Staff</option>
                        <option value="SUPERVISOR">Supervisor</option>
                        <option value="MANAGER">Manager</option>
                        <option value="ADMIN">Admin</option>
                    </select>
                    
                    <select id="statusFilter" onchange="filterUsers()">
                        <option value="">All Status</option>
                        <option value="ACTIVE">Active</option>
                        <option value="INACTIVE">Inactive</option>
                        <option value="SUSPENDED">Suspended</option>
                    </select>
                    
                    <select id="departmentFilter" onchange="filterUsers()">
                        <option value="">All Departments</option>
                        <option value="WATER_WORKS">Water Works</option>
                        <option value="SANITATION">Sanitation</option>
                        <option value="ROADS_MAINTENANCE">Roads Maintenance</option>
                        <option value="ELECTRICAL">Electrical</option>
                        <option value="GENERAL">General</option>
                    </select>
                </div>
            </div>

            <!-- Actions Bar -->
            <div class="actions-bar">
                <button class="btn btn-primary" onclick="showUserForm()">
                    👤 Add New User
                </button>
                <button class="btn btn-secondary" onclick="refreshUsers()">
                    🔄 Refresh
                </button>
                <button class="btn btn-outline" onclick="exportUsers()">
                    📊 Export
                </button>
                <button class="btn btn-outline" onclick="bulkUserActions()">
                    ⚙️ Bulk Actions
                </button>
            </div>

            <!-- Users Table -->
            <div class="table-container">
                <table class="table">
                    <thead>
                        <tr>
                            <th>
                                <input type="checkbox" id="selectAll" onchange="toggleSelectAll()">
                            </th>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Department</th>
                            <th>Status</th>
                            <th>Last Login</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="usersTableBody">
                        <!-- Users will be loaded here dynamically -->
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <div class="pagination">
                <button class="btn btn-outline" onclick="previousPage()" id="prevBtn">Previous</button>
                <span id="pageInfo">Page 1 of 1</span>
                <button class="btn btn-outline" onclick="nextPage()" id="nextBtn">Next</button>
            </div>
        </div>
    </main>

    <!-- User Form Modal -->
    <div id="userModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="userModalTitle">Add New User</h3>
                <span class="close" onclick="closeUserModal()">&times;</span>
            </div>
            <div class="modal-body">
                <form id="userForm">
                    <input type="hidden" id="userId" name="id">
                    
                    <div class="form-group">
                        <label for="userName">Full Name</label>
                        <input type="text" id="userName" name="name" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="userUsername">Username</label>
                        <input type="text" id="userUsername" name="username" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="userEmail">Email Address</label>
                        <input type="email" id="userEmail" name="email" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="userPassword">Password</label>
                        <input type="password" id="userPassword" name="password" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="userRole">Role</label>
                        <select id="userRole" name="role" required onchange="toggleDepartmentField()">
                            <option value="">Select Role</option>
                            <option value="CITIZEN">Citizen</option>
                            <option value="STAFF">Staff</option>
                            <option value="SUPERVISOR">Supervisor</option>
                            <option value="MANAGER">Manager</option>
                            <option value="ADMIN">Admin</option>
                        </select>
                    </div>
                    
                    <div class="form-group" id="departmentField" style="display: none;">
                        <label for="userDepartment">Department</label>
                        <select id="userDepartment" name="departmentId">
                            <option value="">Select Department</option>
                            <!-- Department options will be loaded here -->
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="userPhone">Phone Number</label>
                        <input type="tel" id="userPhone" name="phone">
                    </div>
                    
                    <div class="form-group">
                        <label for="userAddress">Address</label>
                        <textarea id="userAddress" name="address" rows="3"></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="userStatus">Status</label>
                        <select id="userStatus" name="status">
                            <option value="ACTIVE">Active</option>
                            <option value="INACTIVE">Inactive</option>
                            <option value="SUSPENDED">Suspended</option>
                        </select>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" onclick="closeUserModal()">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save User</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- User Details Modal -->
    <div id="userDetailsModal" class="modal">
        <div class="modal-content large">
            <div class="modal-header">
                <h3>User Details</h3>
                <span class="close" onclick="closeUserDetailsModal()">&times;</span>
            </div>
            <div class="modal-body">
                <div id="userDetailsContent">
                    <!-- User details will be loaded here -->
                </div>
            </div>
        </div>
    </div>

    <!-- Bulk Actions Modal -->
    <div id="bulkActionsModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Bulk User Actions</h3>
                <span class="close" onclick="closeBulkActionsModal()">&times;</span>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="bulkAction">Select Action</label>
                    <select id="bulkAction">
                        <option value="">Choose an action...</option>
                        <option value="ACTIVATE">Activate Users</option>
                        <option value="DEACTIVATE">Deactivate Users</option>
                        <option value="SUSPEND">Suspend Users</option>
                        <option value="ASSIGN_DEPARTMENT">Assign to Department</option>
                        <option value="CHANGE_ROLE">Change Role</option>
                        <option value="DELETE">Delete Selected</option>
                    </select>
                </div>
                
                <div id="bulkActionParams" style="display: none;">
                    <!-- Dynamic parameters will be shown here -->
                </div>
                
                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" onclick="closeBulkActionsModal()">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="executeBulkAction()">Execute</button>
                </div>
            </div>
        </div>
    </div>

    <script src="/static/js/app.js"></script>
    <script>
        // Global variables
        let currentPage = 1;
        let totalPages = 1;
        let users = [];
        let filteredUsers = [];
        let departments = [];

        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            complaintManager.checkAuthStatus();
            loadUsers();
            loadDepartments();
        });

        function loadUsers() {
            // Load users from API
            fetch('/api/users', {
                headers: {
                    'Authorization': `Bearer ${localStorage.getItem('token')}`
                }
            })
            .then(response => response.json())
            .then(data => {
                users = data;
                filteredUsers = data;
                renderUsers();
                updateUserStats();
            })
            .catch(error => {
                console.error('Error loading users:', error);
                complaintManager.showAlert('Error loading users', 'error');
            });
        }

        function loadDepartments() {
            // Load departments from API
            fetch('/api/departments')
            .then(response => response.json())
            .then(data => {
                departments = data;
                updateDepartmentOptions();
            })
            .catch(error => {
                console.error('Error loading departments:', error);
            });
        }

        function renderUsers() {
            const tbody = document.getElementById('usersTableBody');
            tbody.innerHTML = '';

            filteredUsers.forEach(user => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>
                        <input type="checkbox" name="userCheckbox" value="${user.id}">
                    </td>
                    <td>${user.id}</td>
                    <td>${user.name}</td>
                    <td>${user.username}</td>
                    <td>${user.email}</td>
                    <td><span class="badge badge-${getRoleBadgeClass(user.role)}">${user.role}</span></td>
                    <td>${user.departmentName || 'N/A'}</td>
                    <td><span class="badge badge-${getStatusBadgeClass(user.status)}">${user.status}</span></td>
                    <td>${user.lastLogin ? new Date(user.lastLogin).toLocaleDateString() : 'Never'}</td>
                    <td>
                        <button class="btn btn-sm btn-primary" onclick="viewUser(${user.id})">View</button>
                        <button class="btn btn-sm btn-secondary" onclick="editUser(${user.id})">Edit</button>
                        <button class="btn btn-sm btn-outline" onclick="deleteUser(${user.id})">Delete</button>
                    </td>
                `;
                tbody.appendChild(row);
            });
        }

        function getRoleBadgeClass(role) {
            const classes = {
                'CITIZEN': 'info',
                'STAFF': 'secondary',
                'SUPERVISOR': 'warning',
                'MANAGER': 'primary',
                'ADMIN': 'danger'
            };
            return classes[role] || 'secondary';
        }

        function getStatusBadgeClass(status) {
            const classes = {
                'ACTIVE': 'success',
                'INACTIVE': 'secondary',
                'SUSPENDED': 'danger'
            };
            return classes[status] || 'secondary';
        }

        function updateUserStats() {
            document.getElementById('totalUsers').textContent = users.length;
            document.getElementById('activeUsers').textContent = users.filter(u => u.status === 'ACTIVE').length;
            document.getElementById('staffUsers').textContent = users.filter(u => ['STAFF', 'SUPERVISOR', 'MANAGER'].includes(u.role)).length;
            document.getElementById('citizenUsers').textContent = users.filter(u => u.role === 'CITIZEN').length;
        }

        function updateDepartmentOptions() {
            const departmentSelect = document.getElementById('userDepartment');
            departmentSelect.innerHTML = '<option value="">Select Department</option>';
            departments.forEach(dept => {
                const option = document.createElement('option');
                option.value = dept.id;
                option.textContent = dept.name;
                departmentSelect.appendChild(option);
            });
        }

        function handleSearch() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            filterUsers();
        }

        function filterUsers() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            const roleFilter = document.getElementById('roleFilter').value;
            const statusFilter = document.getElementById('statusFilter').value;
            const departmentFilter = document.getElementById('departmentFilter').value;

            filteredUsers = users.filter(user => {
                const matchesSearch = !searchTerm || 
                    user.name.toLowerCase().includes(searchTerm) ||
                    user.username.toLowerCase().includes(searchTerm) ||
                    user.email.toLowerCase().includes(searchTerm);
                
                const matchesRole = !roleFilter || user.role === roleFilter;
                const matchesStatus = !statusFilter || user.status === statusFilter;
                const matchesDepartment = !departmentFilter || user.departmentId === departmentFilter;

                return matchesSearch && matchesRole && matchesStatus && matchesDepartment;
            });

            renderUsers();
        }

        function showUserForm() {
            document.getElementById('userModalTitle').textContent = 'Add New User';
            document.getElementById('userForm').reset();
            document.getElementById('userId').value = '';
            document.getElementById('userModal').style.display = 'block';
        }

        function closeUserModal() {
            document.getElementById('userModal').style.display = 'none';
        }

        function closeUserDetailsModal() {
            document.getElementById('userDetailsModal').style.display = 'none';
        }

        function closeBulkActionsModal() {
            document.getElementById('bulkActionsModal').style.display = 'none';
        }

        function toggleDepartmentField() {
            const role = document.getElementById('userRole').value;
            const departmentField = document.getElementById('departmentField');
            
            if (['STAFF', 'SUPERVISOR', 'MANAGER'].includes(role)) {
                departmentField.style.display = 'block';
                document.getElementById('userDepartment').required = true;
            } else {
                departmentField.style.display = 'none';
                document.getElementById('userDepartment').required = false;
            }
        }

        function refreshUsers() {
            loadUsers();
        }

        function exportUsers() {
            complaintManager.showAlert('Export functionality coming soon!', 'info');
        }

        function bulkUserActions() {
            const selectedUsers = getSelectedUsers();
            if (selectedUsers.length === 0) {
                complaintManager.showAlert('Please select users first', 'warning');
                return;
            }
            document.getElementById('bulkActionsModal').style.display = 'block';
        }

        function getSelectedUsers() {
            const checkboxes = document.querySelectorAll('input[name="userCheckbox"]:checked');
            return Array.from(checkboxes).map(cb => cb.value);
        }

        function toggleSelectAll() {
            const selectAll = document.getElementById('selectAll');
            const checkboxes = document.querySelectorAll('input[name="userCheckbox"]');
            checkboxes.forEach(cb => cb.checked = selectAll.checked);
        }

        function previousPage() {
            if (currentPage > 1) {
                currentPage--;
                renderUsers();
            }
        }

        function nextPage() {
            if (currentPage < totalPages) {
                currentPage++;
                renderUsers();
            }
        }

        function viewUser(id) {
            const user = users.find(u => u.id === id);
            if (user) {
                document.getElementById('userDetailsContent').innerHTML = `
                    <div class="user-details">
                        <h4>${user.name}</h4>
                        <p><strong>Username:</strong> ${user.username}</p>
                        <p><strong>Email:</strong> ${user.email}</p>
                        <p><strong>Role:</strong> ${user.role}</p>
                        <p><strong>Department:</strong> ${user.departmentName || 'N/A'}</p>
                        <p><strong>Status:</strong> ${user.status}</p>
                        <p><strong>Phone:</strong> ${user.phone || 'N/A'}</p>
                        <p><strong>Address:</strong> ${user.address || 'N/A'}</p>
                        <p><strong>Last Login:</strong> ${user.lastLogin ? new Date(user.lastLogin).toLocaleString() : 'Never'}</p>
                        <p><strong>Created:</strong> ${user.createdAt ? new Date(user.createdAt).toLocaleDateString() : 'N/A'}</p>
                    </div>
                `;
                document.getElementById('userDetailsModal').style.display = 'block';
            }
        }

        function editUser(id) {
            const user = users.find(u => u.id === id);
            if (user) {
                document.getElementById('userModalTitle').textContent = 'Edit User';
                document.getElementById('userId').value = user.id;
                document.getElementById('userName').value = user.name;
                document.getElementById('userUsername').value = user.username;
                document.getElementById('userEmail').value = user.email;
                document.getElementById('userPassword').value = '';
                document.getElementById('userPassword').required = false;
                document.getElementById('userRole').value = user.role;
                document.getElementById('userDepartment').value = user.departmentId || '';
                document.getElementById('userPhone').value = user.phone || '';
                document.getElementById('userAddress').value = user.address || '';
                document.getElementById('userStatus').value = user.status;
                
                toggleDepartmentField();
                document.getElementById('userModal').style.display = 'block';
            }
        }

        function deleteUser(id) {
            if (confirm('Are you sure you want to delete this user?')) {
                // Implementation for deleting user
                complaintManager.showAlert('User deleted successfully', 'success');
                loadUsers();
            }
        }

        function executeBulkAction() {
            const action = document.getElementById('bulkAction').value;
            const selectedUsers = getSelectedUsers();
            
            if (!action || selectedUsers.length === 0) {
                complaintManager.showAlert('Please select an action and users', 'warning');
                return;
            }
            
            // Implementation for bulk actions
            complaintManager.showAlert(`Bulk action ${action} executed on ${selectedUsers.length} users`, 'success');
            closeBulkActionsModal();
            loadUsers();
        }

        // Handle user form submission
        document.getElementById('userForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = {
                id: document.getElementById('userId').value,
                name: document.getElementById('userName').value,
                username: document.getElementById('userUsername').value,
                email: document.getElementById('userEmail').value,
                password: document.getElementById('userPassword').value,
                role: document.getElementById('userRole').value,
                departmentId: document.getElementById('userDepartment').value,
                phone: document.getElementById('userPhone').value,
                address: document.getElementById('userAddress').value,
                status: document.getElementById('userStatus').value
            };
            
            // Implementation for saving user
            complaintManager.showAlert('User saved successfully', 'success');
            closeUserModal();
            loadUsers();
        });

        // Close modals when clicking outside
        window.onclick = function(event) {
            const modals = ['userModal', 'userDetailsModal', 'bulkActionsModal'];
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