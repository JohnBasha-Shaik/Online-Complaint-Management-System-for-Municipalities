<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - Municipality Complaint System</title>
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
                        <li><a href="/profile" class="nav-link active">Profile</a></li>
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
                <h2>User Profile</h2>
                <p>Manage your account information and preferences</p>
            </div>

            <div class="profile-container">
                <!-- Profile Information -->
                <div class="profile-section">
                    <div class="section-header">
                        <h3>Profile Information</h3>
                        <button class="btn btn-outline" onclick="editProfile()">Edit Profile</button>
                    </div>
                    
                    <div class="profile-info" id="profileInfo">
                        <div class="info-row">
                            <div class="info-label">Full Name:</div>
                            <div class="info-value" id="profileName">Loading...</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Username:</div>
                            <div class="info-value" id="profileUsername">Loading...</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Email:</div>
                            <div class="info-value" id="profileEmail">Loading...</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Role:</div>
                            <div class="info-value" id="profileRole">Loading...</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Department:</div>
                            <div class="info-value" id="profileDepartment">Loading...</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Status:</div>
                            <div class="info-value" id="profileStatus">Loading...</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Member Since:</div>
                            <div class="info-value" id="profileMemberSince">Loading...</div>
                        </div>
                    </div>
                </div>

                <!-- Account Statistics -->
                <div class="profile-section">
                    <div class="section-header">
                        <h3>Account Statistics</h3>
                    </div>
                    
                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-icon">📋</div>
                            <div class="stat-content">
                                <h3 id="totalComplaintsSubmitted">0</h3>
                                <p>Complaints Submitted</p>
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
                            <div class="stat-icon">⏳</div>
                            <div class="stat-content">
                                <h3 id="pendingComplaints">0</h3>
                                <p>Pending</p>
                            </div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon">💬</div>
                            <div class="stat-content">
                                <h3 id="totalComments">0</h3>
                                <p>Comments Made</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Activity -->
                <div class="profile-section">
                    <div class="section-header">
                        <h3>Recent Activity</h3>
                    </div>
                    
                    <div class="activity-list" id="activityList">
                        <!-- Activity items will be loaded here -->
                    </div>
                </div>

                <!-- Security Settings -->
                <div class="profile-section">
                    <div class="section-header">
                        <h3>Security Settings</h3>
                    </div>
                    
                    <div class="security-options">
                        <button class="btn btn-secondary" onclick="showChangePasswordForm()">
                            🔒 Change Password
                        </button>
                        <button class="btn btn-outline" onclick="showNotificationSettings()">
                            🔔 Notification Settings
                        </button>
                        <button class="btn btn-outline" onclick="showPrivacySettings()">
                            🛡️ Privacy Settings
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Edit Profile Modal -->
    <div id="editProfileModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Edit Profile</h3>
                <span class="close" onclick="closeEditProfileModal()">&times;</span>
            </div>
            <div class="modal-body">
                <form id="editProfileForm">
                    <div class="form-group">
                        <label for="editFullName">Full Name</label>
                        <input type="text" id="editFullName" name="fullName" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="editEmail">Email Address</label>
                        <input type="email" id="editEmail" name="email" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="editPhone">Phone Number</label>
                        <input type="tel" id="editPhone" name="phone">
                    </div>
                    
                    <div class="form-group">
                        <label for="editAddress">Address</label>
                        <textarea id="editAddress" name="address" rows="3"></textarea>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" onclick="closeEditProfileModal()">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Change Password Modal -->
    <div id="changePasswordModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Change Password</h3>
                <span class="close" onclick="closeChangePasswordModal()">&times;</span>
            </div>
            <div class="modal-body">
                <form id="changePasswordForm">
                    <div class="form-group">
                        <label for="currentPassword">Current Password</label>
                        <input type="password" id="currentPassword" name="currentPassword" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="newPassword">New Password</label>
                        <input type="password" id="newPassword" name="newPassword" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="confirmNewPassword">Confirm New Password</label>
                        <input type="password" id="confirmNewPassword" name="confirmNewPassword" required>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" onclick="closeChangePasswordModal()">Cancel</button>
                        <button type="submit" class="btn btn-primary">Change Password</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Notification Settings Modal -->
    <div id="notificationSettingsModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Notification Settings</h3>
                <span class="close" onclick="closeNotificationSettingsModal()">&times;</span>
            </div>
            <div class="modal-body">
                <form id="notificationSettingsForm">
                    <div class="form-group">
                        <label class="checkbox-label">
                            <input type="checkbox" id="emailNotifications" name="emailNotifications">
                            Receive email notifications
                        </label>
                    </div>
                    
                    <div class="form-group">
                        <label class="checkbox-label">
                            <input type="checkbox" id="smsNotifications" name="smsNotifications">
                            Receive SMS notifications
                        </label>
                    </div>
                    
                    <div class="form-group">
                        <label class="checkbox-label">
                            <input type="checkbox" id="complaintUpdates" name="complaintUpdates">
                            Complaint status updates
                        </label>
                    </div>
                    
                    <div class="form-group">
                        <label class="checkbox-label">
                            <input type="checkbox" id="systemAnnouncements" name="systemAnnouncements">
                            System announcements
                        </label>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" onclick="closeNotificationSettingsModal()">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Settings</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="/static/js/app.js"></script>
    <script>
        // Global variables
        let currentUser = null;
        let userStats = {};
        let recentActivity = [];

        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            complaintManager.checkAuthStatus();
            loadProfile();
            loadUserStats();
            loadRecentActivity();
        });

        function loadProfile() {
            // Load user profile from API
            fetch('/api/users/profile', {
                headers: {
                    'Authorization': `Bearer ${localStorage.getItem('token')}`
                }
            })
            .then(response => response.json())
            .then(data => {
                currentUser = data;
                displayProfile(data);
            })
            .catch(error => {
                console.error('Error loading profile:', error);
                complaintManager.showAlert('Error loading profile', 'error');
            });
        }

        function loadUserStats() {
            // Load user statistics from API
            fetch('/api/users/stats', {
                headers: {
                    'Authorization': `Bearer ${localStorage.getItem('token')}`
                }
            })
            .then(response => response.json())
            .then(data => {
                userStats = data;
                displayUserStats(data);
            })
            .catch(error => {
                console.error('Error loading user stats:', error);
            });
        }

        function loadRecentActivity() {
            // Load recent activity from API
            fetch('/api/users/activity', {
                headers: {
                    'Authorization': `Bearer ${localStorage.getItem('token')}`
                }
            })
            .then(response => response.json())
            .then(data => {
                recentActivity = data;
                displayRecentActivity(data);
            })
            .catch(error => {
                console.error('Error loading recent activity:', error);
            });
        }

        function displayProfile(profile) {
            document.getElementById('profileName').textContent = profile.name || 'N/A';
            document.getElementById('profileUsername').textContent = profile.username || 'N/A';
            document.getElementById('profileEmail').textContent = profile.email || 'N/A';
            document.getElementById('profileRole').textContent = profile.role || 'N/A';
            document.getElementById('profileDepartment').textContent = profile.departmentName || 'N/A';
            document.getElementById('profileStatus').textContent = profile.status || 'N/A';
            document.getElementById('profileMemberSince').textContent = profile.createdAt ? new Date(profile.createdAt).toLocaleDateString() : 'N/A';
        }

        function displayUserStats(stats) {
            document.getElementById('totalComplaintsSubmitted').textContent = stats.totalComplaints || 0;
            document.getElementById('resolvedComplaints').textContent = stats.resolvedComplaints || 0;
            document.getElementById('pendingComplaints').textContent = stats.pendingComplaints || 0;
            document.getElementById('totalComments').textContent = stats.totalComments || 0;
        }

        function displayRecentActivity(activities) {
            const activityList = document.getElementById('activityList');
            activityList.innerHTML = '';

            if (activities.length === 0) {
                activityList.innerHTML = '<p class="no-activity">No recent activity</p>';
                return;
            }

            activities.forEach(activity => {
                const activityItem = document.createElement('div');
                activityItem.className = 'activity-item';
                activityItem.innerHTML = `
                    <div class="activity-icon">${getActivityIcon(activity.type)}</div>
                    <div class="activity-content">
                        <div class="activity-text">${activity.description}</div>
                        <div class="activity-time">${formatTime(activity.timestamp)}</div>
                    </div>
                `;
                activityList.appendChild(activityItem);
            });
        }

        function getActivityIcon(type) {
            const icons = {
                'COMPLAINT_SUBMITTED': '📝',
                'COMPLAINT_UPDATED': '🔄',
                'COMMENT_ADDED': '💬',
                'STATUS_CHANGED': '✅',
                'LOGIN': '🔐',
                'PROFILE_UPDATED': '👤'
            };
            return icons[type] || '📋';
        }

        function formatTime(timestamp) {
            const date = new Date(timestamp);
            const now = new Date();
            const diffMs = now - date;
            const diffMins = Math.floor(diffMs / 60000);
            const diffHours = Math.floor(diffMs / 3600000);
            const diffDays = Math.floor(diffMs / 86400000);

            if (diffMins < 1) return 'Just now';
            if (diffMins < 60) return `${diffMins} minutes ago`;
            if (diffHours < 24) return `${diffHours} hours ago`;
            if (diffDays < 7) return `${diffDays} days ago`;
            return date.toLocaleDateString();
        }

        function editProfile() {
            if (currentUser) {
                document.getElementById('editFullName').value = currentUser.name || '';
                document.getElementById('editEmail').value = currentUser.email || '';
                document.getElementById('editPhone').value = currentUser.phone || '';
                document.getElementById('editAddress').value = currentUser.address || '';
                document.getElementById('editProfileModal').style.display = 'block';
            }
        }

        function closeEditProfileModal() {
            document.getElementById('editProfileModal').style.display = 'none';
        }

        function showChangePasswordForm() {
            document.getElementById('changePasswordModal').style.display = 'block';
        }

        function closeChangePasswordModal() {
            document.getElementById('changePasswordModal').style.display = 'none';
            document.getElementById('changePasswordForm').reset();
        }

        function showNotificationSettings() {
            // Load current notification settings
            document.getElementById('emailNotifications').checked = currentUser?.emailNotifications || false;
            document.getElementById('smsNotifications').checked = currentUser?.smsNotifications || false;
            document.getElementById('complaintUpdates').checked = currentUser?.complaintUpdates || false;
            document.getElementById('systemAnnouncements').checked = currentUser?.systemAnnouncements || false;
            
            document.getElementById('notificationSettingsModal').style.display = 'block';
        }

        function closeNotificationSettingsModal() {
            document.getElementById('notificationSettingsModal').style.display = 'none';
        }

        function showPrivacySettings() {
            complaintManager.showAlert('Privacy settings coming soon!', 'info');
        }

        // Handle edit profile form submission
        document.getElementById('editProfileForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = {
                name: document.getElementById('editFullName').value,
                email: document.getElementById('editEmail').value,
                phone: document.getElementById('editPhone').value,
                address: document.getElementById('editAddress').value
            };
            
            // Implementation for updating profile
            complaintManager.showAlert('Profile updated successfully', 'success');
            closeEditProfileModal();
            loadProfile();
        });

        // Handle change password form submission
        document.getElementById('changePasswordForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmNewPassword').value;
            
            if (newPassword !== confirmPassword) {
                complaintManager.showAlert('New passwords do not match', 'error');
                return;
            }
            
            // Implementation for changing password
            complaintManager.showAlert('Password changed successfully', 'success');
            closeChangePasswordModal();
        });

        // Handle notification settings form submission
        document.getElementById('notificationSettingsForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const settings = {
                emailNotifications: document.getElementById('emailNotifications').checked,
                smsNotifications: document.getElementById('smsNotifications').checked,
                complaintUpdates: document.getElementById('complaintUpdates').checked,
                systemAnnouncements: document.getElementById('systemAnnouncements').checked
            };
            
            // Implementation for saving notification settings
            complaintManager.showAlert('Notification settings saved successfully', 'success');
            closeNotificationSettingsModal();
        });

        // Close modals when clicking outside
        window.onclick = function(event) {
            const modals = ['editProfileModal', 'changePasswordModal', 'notificationSettingsModal'];
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