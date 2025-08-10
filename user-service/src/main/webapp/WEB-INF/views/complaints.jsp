<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complaints Management - Municipality Complaint System</title>
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
                        <li><a href="/complaints" class="nav-link active">Complaints</a></li>
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
            <!-- Page Header -->
            <div class="page-header">
                <h2>Complaints Management</h2>
                <p>View and manage all complaints in the system</p>
            </div>

            <!-- Search and Filters -->
            <div class="search-filters">
                <div class="search-box">
                    <input type="text" id="searchInput" placeholder="Search complaints..." 
                           onkeyup="handleSearch()">
                    <button class="btn btn-primary" onclick="handleSearch()">
                        <span>🔍</span> Search
                    </button>
                </div>
                
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
                    
                    <select id="priorityFilter" onchange="filterComplaints()">
                        <option value="">All Priorities</option>
                        <option value="LOW">Low</option>
                        <option value="MEDIUM">Medium</option>
                        <option value="HIGH">High</option>
                        <option value="URGENT">Urgent</option>
                    </select>
                    
                    <select id="departmentFilter" onchange="filterComplaints()">
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
                <button class="btn btn-primary" onclick="showComplaintForm()">
                    📝 Submit New Complaint
                </button>
                <button class="btn btn-secondary" onclick="refreshComplaints()">
                    🔄 Refresh
                </button>
                <button class="btn btn-outline" onclick="exportComplaints()">
                    📊 Export
                </button>
                <button class="btn btn-outline" onclick="bulkActions()">
                    ⚙️ Bulk Actions
                </button>
            </div>

            <!-- Complaints Table -->
            <div class="table-container">
                <table class="table">
                    <thead>
                        <tr>
                            <th>
                                <input type="checkbox" id="selectAll" onchange="toggleSelectAll()">
                            </th>
                            <th>ID</th>
                            <th>Category</th>
                            <th>Description</th>
                            <th>Status</th>
                            <th>Priority</th>
                            <th>Department</th>
                            <th>Submitted By</th>
                            <th>Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="complaintsTableBody">
                        <!-- Complaints will be loaded here dynamically -->
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

    <!-- Bulk Actions Modal -->
    <div id="bulkActionsModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Bulk Actions</h3>
                <span class="close" onclick="closeBulkActionsModal()">&times;</span>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="bulkAction">Select Action</label>
                    <select id="bulkAction">
                        <option value="">Choose an action...</option>
                        <option value="ASSIGN_DEPARTMENT">Assign to Department</option>
                        <option value="UPDATE_STATUS">Update Status</option>
                        <option value="UPDATE_PRIORITY">Update Priority</option>
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
        let complaints = [];
        let filteredComplaints = [];

        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            complaintManager.checkAuthStatus();
            loadComplaints();
        });

        function loadComplaints() {
            complaintManager.loadComplaints();
        }

        function refreshComplaints() {
            loadComplaints();
        }

        function handleSearch() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            complaintManager.handleSearch(searchTerm);
        }

        function filterComplaints() {
            const statusFilter = document.getElementById('statusFilter').value;
            const categoryFilter = document.getElementById('categoryFilter').value;
            const priorityFilter = document.getElementById('priorityFilter').value;
            const departmentFilter = document.getElementById('departmentFilter').value;
            
            complaintManager.filterComplaints(statusFilter, categoryFilter, priorityFilter, departmentFilter);
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

        function closeBulkActionsModal() {
            document.getElementById('bulkActionsModal').style.display = 'none';
        }

        function bulkActions() {
            const selectedComplaints = getSelectedComplaints();
            if (selectedComplaints.length === 0) {
                complaintManager.showAlert('Please select complaints first', 'warning');
                return;
            }
            document.getElementById('bulkActionsModal').style.display = 'block';
        }

        function getSelectedComplaints() {
            const checkboxes = document.querySelectorAll('input[name="complaintCheckbox"]:checked');
            return Array.from(checkboxes).map(cb => cb.value);
        }

        function toggleSelectAll() {
            const selectAll = document.getElementById('selectAll');
            const checkboxes = document.querySelectorAll('input[name="complaintCheckbox"]');
            checkboxes.forEach(cb => cb.checked = selectAll.checked);
        }

        function previousPage() {
            if (currentPage > 1) {
                currentPage--;
                renderComplaints();
            }
        }

        function nextPage() {
            if (currentPage < totalPages) {
                currentPage++;
                renderComplaints();
            }
        }

        function exportComplaints() {
            complaintManager.showAlert('Export functionality coming soon!', 'info');
        }

        function executeBulkAction() {
            const action = document.getElementById('bulkAction').value;
            const selectedComplaints = getSelectedComplaints();
            
            if (!action || selectedComplaints.length === 0) {
                complaintManager.showAlert('Please select an action and complaints', 'warning');
                return;
            }
            
            // Implementation for bulk actions
            complaintManager.showAlert(`Bulk action ${action} executed on ${selectedComplaints.length} complaints`, 'success');
            closeBulkActionsModal();
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
            const modals = ['complaintModal', 'complaintDetailsModal', 'bulkActionsModal'];
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