// Municipal Complaint Management System - JavaScript

class ComplaintManager {
    constructor() {
        this.baseUrl = '/api';
        this.token = localStorage.getItem('jwt_token');
        this.currentUser = JSON.parse(localStorage.getItem('current_user') || '{}');
        this.init();
    }

    init() {
        this.setupEventListeners();
        this.checkAuthStatus();
        this.loadDashboard();
    }

    setupEventListeners() {
        // Login form
        const loginForm = document.getElementById('loginForm');
        if (loginForm) {
            loginForm.addEventListener('submit', (e) => this.handleLogin(e));
        }

        // Registration form
        const registerForm = document.getElementById('registerForm');
        if (registerForm) {
            registerForm.addEventListener('submit', (e) => this.handleRegister(e));
        }

        // Complaint form
        const complaintForm = document.getElementById('complaintForm');
        if (complaintForm) {
            complaintForm.addEventListener('submit', (e) => this.handleComplaintSubmit(e));
        }

        // Logout button
        const logoutBtn = document.getElementById('logoutBtn');
        if (logoutBtn) {
            logoutBtn.addEventListener('click', () => this.handleLogout());
        }

        // Search functionality
        const searchInput = document.getElementById('searchInput');
        if (searchInput) {
            searchInput.addEventListener('input', (e) => this.handleSearch(e.target.value));
        }

        // Filter dropdowns
        const statusFilter = document.getElementById('statusFilter');
        if (statusFilter) {
            statusFilter.addEventListener('change', (e) => this.filterComplaints());
        }

        const categoryFilter = document.getElementById('categoryFilter');
        if (categoryFilter) {
            categoryFilter.addEventListener('change', (e) => this.filterComplaints());
        }
    }

    async handleLogin(event) {
        event.preventDefault();
        const formData = new FormData(event.target);
        const loginData = {
            username: formData.get('username'),
            password: formData.get('password')
        };

        try {
            this.showLoading();
            const response = await this.apiCall('/users/login', 'POST', loginData);
            
            if (response.token) {
                this.token = response.token;
                this.currentUser = response.user;
                localStorage.setItem('jwt_token', this.token);
                localStorage.setItem('current_user', JSON.stringify(this.currentUser));
                
                this.showAlert('Login successful!', 'success');
                setTimeout(() => {
                    window.location.href = '/dashboard';
                }, 1000);
            }
        } catch (error) {
            this.showAlert(error.message || 'Login failed', 'danger');
        } finally {
            this.hideLoading();
        }
    }

    async handleRegister(event) {
        event.preventDefault();
        const formData = new FormData(event.target);
        const registerData = {
            name: formData.get('name'),
            email: formData.get('email'),
            username: formData.get('username'),
            password: formData.get('password'),
            role: formData.get('role')
        };

        try {
            this.showLoading();
            const response = await this.apiCall('/users/register', 'POST', registerData);
            
            this.showAlert('Registration successful! Please login.', 'success');
            event.target.reset();
            
            // Switch to login form
            this.showLoginForm();
        } catch (error) {
            this.showAlert(error.message || 'Registration failed', 'danger');
        } finally {
            this.hideLoading();
        }
    }

    async handleComplaintSubmit(event) {
        event.preventDefault();
        const formData = new FormData(event.target);
        const complaintData = {
            category: formData.get('category'),
            description: formData.get('description')
        };

        try {
            this.showLoading();
            const response = await this.apiCall('/complaints/create', 'POST', complaintData);
            
            this.showAlert('Complaint submitted successfully!', 'success');
            event.target.reset();
            
            // Refresh complaints list
            this.loadComplaints();
        } catch (error) {
            this.showAlert(error.message || 'Failed to submit complaint', 'danger');
        } finally {
            this.hideLoading();
        }
    }

    async loadDashboard() {
        if (!this.token) return;

        try {
            const [complaints, stats] = await Promise.all([
                this.apiCall('/complaints/my-complaints', 'GET'),
                this.getDashboardStats()
            ]);

            this.renderDashboard(complaints, stats);
        } catch (error) {
            console.error('Error loading dashboard:', error);
        }
    }

    async loadComplaints() {
        if (!this.token) return;

        try {
            const complaints = await this.apiCall('/complaints/all', 'GET');
            this.renderComplaints(complaints);
        } catch (error) {
            console.error('Error loading complaints:', error);
        }
    }

    async getDashboardStats() {
        if (this.currentUser.role === 'ADMIN') {
            try {
                const [totalComplaints, pendingComplaints, resolvedComplaints] = await Promise.all([
                    this.apiCall('/complaints/all', 'GET'),
                    this.apiCall('/complaints/status/SUBMITTED', 'GET'),
                    this.apiCall('/complaints/status/RESOLVED', 'GET')
                ]);

                return {
                    total: totalComplaints.length,
                    pending: pendingComplaints.length,
                    resolved: resolvedComplaints.length
                };
            } catch (error) {
                console.error('Error loading stats:', error);
                return { total: 0, pending: 0, resolved: 0 };
            }
        } else {
            try {
                const myComplaints = await this.apiCall('/complaints/my-complaints', 'GET');
                return {
                    total: myComplaints.length,
                    pending: myComplaints.filter(c => c.status === 'SUBMITTED').length,
                    resolved: myComplaints.filter(c => c.status === 'RESOLVED').length
                };
            } catch (error) {
                console.error('Error loading stats:', error);
                return { total: 0, pending: 0, resolved: 0 };
            }
        }
    }

    renderDashboard(complaints, stats) {
        const dashboardContainer = document.getElementById('dashboardContent');
        if (!dashboardContainer) return;

        dashboardContainer.innerHTML = `
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-number">${stats.total}</div>
                    <div class="stat-label">Total Complaints</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${stats.pending}</div>
                    <div class="stat-label">Pending</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${stats.resolved}</div>
                    <div class="stat-label">Resolved</div>
                </div>
            </div>
            
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Recent Complaints</h3>
                </div>
                <div class="table-responsive">
                    ${this.renderComplaintsTable(complaints.slice(0, 5))}
                </div>
            </div>
        `;
    }

    renderComplaints(complaints) {
        const complaintsContainer = document.getElementById('complaintsList');
        if (!complaintsContainer) return;

        complaintsContainer.innerHTML = `
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">All Complaints</h3>
                    <div class="row">
                        <div class="col-md-4">
                            <select id="statusFilter" class="form-select">
                                <option value="">All Statuses</option>
                                <option value="SUBMITTED">Submitted</option>
                                <option value="UNDER_REVIEW">Under Review</option>
                                <option value="IN_PROGRESS">In Progress</option>
                                <option value="RESOLVED">Resolved</option>
                                <option value="CLOSED">Closed</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <select id="categoryFilter" class="form-select">
                                <option value="">All Categories</option>
                                <option value="WATER">Water</option>
                                <option value="SANITATION">Sanitation</option>
                                <option value="ROADS">Roads</option>
                                <option value="ELECTRICITY">Electricity</option>
                                <option value="DRAINAGE">Drainage</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <input type="text" id="searchInput" class="form-control" placeholder="Search complaints...">
                        </div>
                    </div>
                </div>
                <div class="table-responsive">
                    ${this.renderComplaintsTable(complaints)}
                </div>
            </div>
        `;

        // Re-attach event listeners
        this.setupEventListeners();
    }

    renderComplaintsTable(complaints) {
        if (!complaints || complaints.length === 0) {
            return '<p class="text-center p-3">No complaints found.</p>';
        }

        return `
            <table class="table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Category</th>
                        <th>Description</th>
                        <th>Status</th>
                        <th>Created</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    ${complaints.map(complaint => `
                        <tr>
                            <td>#${complaint.id}</td>
                            <td>${complaint.category}</td>
                            <td>${complaint.description.substring(0, 50)}${complaint.description.length > 50 ? '...' : ''}</td>
                            <td>${this.getStatusBadge(complaint.status)}</td>
                            <td>${new Date(complaint.createdAt).toLocaleDateString()}</td>
                            <td>
                                <button class="btn btn-sm btn-primary" onclick="complaintManager.viewComplaint(${complaint.id})">View</button>
                                ${this.currentUser.role !== 'CITIZEN' ? `
                                    <button class="btn btn-sm btn-warning" onclick="complaintManager.updateStatus(${complaint.id})">Update</button>
                                ` : ''}
                            </td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
        `;
    }

    getStatusBadge(status) {
        const badgeClasses = {
            'SUBMITTED': 'badge-secondary',
            'UNDER_REVIEW': 'badge-info',
            'IN_PROGRESS': 'badge-warning',
            'RESOLVED': 'badge-success',
            'CLOSED': 'badge-secondary',
            'REJECTED': 'badge-danger'
        };

        return `<span class="badge ${badgeClasses[status] || 'badge-secondary'}">${status.replace('_', ' ')}</span>`;
    }

    async viewComplaint(id) {
        try {
            const complaint = await this.apiCall(`/complaints/${id}`, 'GET');
            this.showComplaintModal(complaint);
        } catch (error) {
            this.showAlert('Error loading complaint details', 'danger');
        }
    }

    showComplaintModal(complaint) {
        const modal = document.createElement('div');
        modal.className = 'modal-overlay';
        modal.innerHTML = `
            <div class="modal">
                <div class="modal-header">
                    <h3>Complaint #${complaint.id}</h3>
                    <button class="close-btn" onclick="this.closest('.modal-overlay').remove()">&times;</button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <p><strong>Category:</strong> ${complaint.category}</p>
                            <p><strong>Status:</strong> ${this.getStatusBadge(complaint.status)}</p>
                            <p><strong>Created:</strong> ${new Date(complaint.createdAt).toLocaleString()}</p>
                        </div>
                        <div class="col-md-6">
                            <p><strong>Department:</strong> ${complaint.assignedDepartment || 'Not Assigned'}</p>
                            <p><strong>Staff:</strong> ${complaint.assignedStaffId || 'Not Assigned'}</p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Description:</label>
                        <p>${complaint.description}</p>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Comments:</label>
                        <div class="comments-section">
                            ${complaint.comments && complaint.comments.length > 0 ? 
                                complaint.comments.map(comment => `
                                    <div class="comment">
                                        <strong>${comment.authorName}</strong> (${comment.authorRole})
                                        <small>${new Date(comment.createdAt).toLocaleString()}</small>
                                        <p>${comment.text}</p>
                                    </div>
                                `).join('') : 
                                '<p>No comments yet.</p>'
                            }
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Add Comment:</label>
                        <textarea id="commentText" class="form-control" rows="3" placeholder="Enter your comment..."></textarea>
                        <button class="btn btn-primary mt-2" onclick="complaintManager.addComment(${complaint.id})">Add Comment</button>
                    </div>
                </div>
            </div>
        `;

        document.body.appendChild(modal);
    }

    async addComment(complaintId) {
        const commentText = document.getElementById('commentText').value;
        if (!commentText.trim()) {
            this.showAlert('Please enter a comment', 'warning');
            return;
        }

        try {
            await this.apiCall(`/complaints/${complaintId}/comments`, 'POST', { text: commentText });
            this.showAlert('Comment added successfully', 'success');
            this.viewComplaint(complaintId); // Refresh the modal
        } catch (error) {
            this.showAlert('Error adding comment', 'danger');
        }
    }

    async updateStatus(complaintId) {
        const newStatus = prompt('Enter new status (SUBMITTED, UNDER_REVIEW, IN_PROGRESS, RESOLVED, CLOSED):');
        if (!newStatus) return;

        try {
            await this.apiCall(`/complaints/${complaintId}/status`, 'PUT', { status: newStatus });
            this.showAlert('Status updated successfully', 'success');
            this.loadComplaints();
        } catch (error) {
            this.showAlert('Error updating status', 'danger');
        }
    }

    handleSearch(query) {
        const rows = document.querySelectorAll('#complaintsList tbody tr');
        rows.forEach(row => {
            const text = row.textContent.toLowerCase();
            const visible = text.includes(query.toLowerCase());
            row.style.display = visible ? '' : 'none';
        });
    }

    filterComplaints() {
        const statusFilter = document.getElementById('statusFilter').value;
        const categoryFilter = document.getElementById('categoryFilter').value;
        
        // Implement filtering logic here
        console.log('Filtering by:', { status: statusFilter, category: categoryFilter });
    }

    handleLogout() {
        localStorage.removeItem('jwt_token');
        localStorage.removeItem('current_user');
        this.token = null;
        this.currentUser = {};
        window.location.href = '/';
    }

    checkAuthStatus() {
        if (this.token && this.currentUser.id) {
            this.showAuthenticatedUI();
        } else {
            this.showLoginForm();
        }
    }

    showAuthenticatedUI() {
        const authSection = document.getElementById('authSection');
        const dashboardSection = document.getElementById('dashboardSection');
        
        if (authSection) authSection.style.display = 'none';
        if (dashboardSection) dashboardSection.style.display = 'block';
        
        this.updateNavigation();
    }

    showLoginForm() {
        const authSection = document.getElementById('authSection');
        const dashboardSection = document.getElementById('dashboardSection');
        
        if (authSection) authSection.style.display = 'block';
        if (dashboardSection) dashboardSection.style.display = 'none';
    }

    updateNavigation() {
        const navMenu = document.querySelector('.nav-menu');
        if (!navMenu) return;

        const role = this.currentUser.role;
        let menuItems = '';

        if (role === 'ADMIN') {
            menuItems = `
                <li><a href="/dashboard">Dashboard</a></li>
                <li><a href="/complaints">All Complaints</a></li>
                <li><a href="/departments">Departments</a></li>
                <li><a href="/users">Users</a></li>
            `;
        } else if (role === 'MUNICIPAL_STAFF') {
            menuItems = `
                <li><a href="/dashboard">Dashboard</a></li>
                <li><a href="/complaints">My Complaints</a></li>
                <li><a href="/departments">My Department</a></li>
            `;
        } else {
            menuItems = `
                <li><a href="/dashboard">Dashboard</a></li>
                <li><a href="/complaints">My Complaints</a></li>
                <li><a href="/submit">Submit Complaint</a></li>
            `;
        }

        menuItems += `<li><a href="#" id="logoutBtn">Logout</a></li>`;
        navMenu.innerHTML = menuItems;
    }

    async apiCall(endpoint, method, data = null) {
        const url = `${this.baseUrl}${endpoint}`;
        const options = {
            method,
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${this.token}`
            }
        };

        if (data && method !== 'GET') {
            options.body = JSON.stringify(data);
        }

        const response = await fetch(url, options);
        
        if (!response.ok) {
            const errorData = await response.json().catch(() => ({}));
            throw new Error(errorData.message || `HTTP ${response.status}`);
        }

        return response.json();
    }

    showAlert(message, type) {
        const alertContainer = document.getElementById('alertContainer') || this.createAlertContainer();
        
        const alert = document.createElement('div');
        alert.className = `alert alert-${type}`;
        alert.innerHTML = `
            ${message}
            <button type="button" class="close" onclick="this.parentElement.remove()">&times;</button>
        `;
        
        alertContainer.appendChild(alert);
        
        setTimeout(() => {
            if (alert.parentElement) {
                alert.remove();
            }
        }, 5000);
    }

    createAlertContainer() {
        const container = document.createElement('div');
        container.id = 'alertContainer';
        container.style.position = 'fixed';
        container.style.top = '20px';
        container.style.right = '20px';
        container.style.zIndex = '9999';
        container.style.maxWidth = '400px';
        document.body.appendChild(container);
        return container;
    }

    showLoading() {
        const loading = document.createElement('div');
        loading.id = 'loadingOverlay';
        loading.innerHTML = '<div class="spinner"></div>';
        loading.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
        `;
        document.body.appendChild(loading);
    }

    hideLoading() {
        const loading = document.getElementById('loadingOverlay');
        if (loading) {
            loading.remove();
        }
    }
}

// Initialize the application
document.addEventListener('DOMContentLoaded', () => {
    window.complaintManager = new ComplaintManager();
});

// Add modal styles
const modalStyles = document.createElement('style');
modalStyles.textContent = `
    .modal-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.5);
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 10000;
    }
    
    .modal {
        background: white;
        border-radius: 8px;
        max-width: 800px;
        width: 90%;
        max-height: 90vh;
        overflow-y: auto;
    }
    
    .modal-header {
        padding: 1rem 2rem;
        border-bottom: 1px solid #ecf0f1;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    
    .modal-body {
        padding: 2rem;
    }
    
    .close-btn {
        background: none;
        border: none;
        font-size: 1.5rem;
        cursor: pointer;
        color: #666;
    }
    
    .close-btn:hover {
        color: #333;
    }
    
    .comments-section {
        max-height: 200px;
        overflow-y: auto;
        border: 1px solid #ecf0f1;
        padding: 1rem;
        border-radius: 4px;
    }
    
    .comment {
        border-bottom: 1px solid #ecf0f1;
        padding: 0.5rem 0;
    }
    
    .comment:last-child {
        border-bottom: none;
    }
    
    .comment small {
        color: #666;
        display: block;
        margin-bottom: 0.5rem;
    }
`;
document.head.appendChild(modalStyles);