<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Municipal Complaint Management System</title>
    <link rel="stylesheet" href="/static/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="header-content">
            <a href="/" class="logo">
                <i class="fas fa-city"></i> Municipal CMS
            </a>
            <nav>
                <ul class="nav-menu">
                    <li><a href="/"><i class="fas fa-home"></i> Home</a></li>
                    <li><a href="/about"><i class="fas fa-info-circle"></i> About</a></li>
                    <li><a href="/contact"><i class="fas fa-envelope"></i> Contact</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <!-- Main Content -->
    <main class="container">
        <!-- Hero Section -->
        <div class="hero-section text-center mb-3">
            <h1 class="hero-title">Welcome to Municipal Complaint Management System</h1>
            <p class="hero-subtitle">Efficiently manage and resolve citizen complaints for better municipal services</p>
            <div class="hero-buttons">
                <a href="#authSection" class="btn btn-primary btn-lg">
                    <i class="fas fa-sign-in-alt"></i> Get Started
                </a>
                <a href="#features" class="btn btn-outline btn-lg">
                    <i class="fas fa-info-circle"></i> Learn More
                </a>
            </div>
        </div>

        <!-- Features Section -->
        <div id="features" class="features-section mb-3">
            <div class="row">
                <div class="col-md-4">
                    <div class="feature-card text-center">
                        <div class="feature-icon">
                            <i class="fas fa-clipboard-list fa-3x"></i>
                        </div>
                        <h3>Submit Complaints</h3>
                        <p>Easily submit complaints about municipal services like water, sanitation, roads, and more.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card text-center">
                        <div class="feature-icon">
                            <i class="fas fa-tasks fa-3x"></i>
                        </div>
                        <h3>Track Progress</h3>
                        <p>Monitor the status of your complaints in real-time and receive updates on resolution progress.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card text-center">
                        <div class="feature-icon">
                            <i class="fas fa-users fa-3x"></i>
                        </div>
                        <h3>Department Management</h3>
                        <p>Efficiently assign and manage complaints across different municipal departments.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Authentication Section -->
        <div id="authSection" class="auth-section">
            <div class="row">
                <!-- Login Form -->
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="fas fa-sign-in-alt"></i> Login
                            </h3>
                        </div>
                        <form id="loginForm" class="login-form">
                            <div class="form-group">
                                <label for="loginUsername" class="form-label">Username</label>
                                <input type="text" id="loginUsername" name="username" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label for="loginPassword" class="form-label">Password</label>
                                <input type="password" id="loginPassword" name="password" class="form-control" required>
                            </div>
                            <button type="submit" class="btn btn-primary btn-block">
                                <i class="fas fa-sign-in-alt"></i> Login
                            </button>
                        </form>
                        <div class="text-center mt-2">
                            <a href="#" onclick="showRegisterForm()" class="text-muted">
                                Don't have an account? Register here
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Registration Form -->
                <div class="col-md-6">
                    <div class="card" id="registerCard" style="display: none;">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="fas fa-user-plus"></i> Register
                            </h3>
                        </div>
                        <form id="registerForm" class="register-form">
                            <div class="form-group">
                                <label for="registerName" class="form-label">Full Name</label>
                                <input type="text" id="registerName" name="name" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label for="registerEmail" class="form-label">Email</label>
                                <input type="email" id="registerEmail" name="email" class="form-label" required>
                            </div>
                            <div class="form-group">
                                <label for="registerUsername" class="form-label">Username</label>
                                <input type="text" id="registerUsername" name="username" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label for="registerPassword" class="form-label">Password</label>
                                <input type="password" id="registerPassword" name="password" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label for="registerRole" class="form-label">Role</label>
                                <select id="registerRole" name="role" class="form-select" required>
                                    <option value="">Select Role</option>
                                    <option value="CITIZEN">Citizen</option>
                                    <option value="MUNICIPAL_STAFF">Municipal Staff</option>
                                    <option value="ADMIN">Administrator</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-success btn-block">
                                <i class="fas fa-user-plus"></i> Register
                            </button>
                        </form>
                        <div class="text-center mt-2">
                            <a href="#" onclick="showLoginForm()" class="text-muted">
                                Already have an account? Login here
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Dashboard Section (Hidden by default) -->
        <div id="dashboardSection" style="display: none;">
            <div class="dashboard-header mb-3">
                <h2>Welcome, <span id="userName">User</span>!</h2>
                <p>Manage your complaints and track their progress</p>
            </div>
            
            <div id="dashboardContent">
                <!-- Dashboard content will be loaded dynamically -->
            </div>
        </div>

        <!-- Statistics Section -->
        <div class="stats-section mb-3">
            <div class="row">
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-clipboard-list fa-2x"></i>
                        </div>
                        <div class="stat-number">1000+</div>
                        <div class="stat-label">Complaints Resolved</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-users fa-2x"></i>
                        </div>
                        <div class="stat-number">500+</div>
                        <div class="stat-label">Active Users</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-building fa-2x"></i>
                        </div>
                        <div class="stat-number">10+</div>
                        <div class="stat-label">Departments</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fas fa-clock fa-2x"></i>
                        </div>
                        <div class="stat-number">24/7</div>
                        <div class="stat-label">Support Available</div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h4>Municipal Complaint Management System</h4>
                    <p>Empowering citizens and municipal staff for better public services.</p>
                </div>
                <div class="col-md-6 text-right">
                    <h4>Quick Links</h4>
                    <ul class="footer-links">
                        <li><a href="/privacy">Privacy Policy</a></li>
                        <li><a href="/terms">Terms of Service</a></li>
                        <li><a href="/help">Help & Support</a></li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom text-center mt-3">
                <p>&copy; 2024 Municipal CMS. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <!-- JavaScript -->
    <script src="/static/js/app.js"></script>
    <script>
        function showRegisterForm() {
            document.getElementById('loginForm').parentElement.parentElement.style.display = 'none';
            document.getElementById('registerCard').style.display = 'block';
        }

        function showLoginForm() {
            document.getElementById('loginForm').parentElement.parentElement.style.display = 'block';
            document.getElementById('registerCard').style.display = 'none';
        }

        // Add smooth scrolling for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
    </script>

    <style>
        .hero-section {
            padding: 4rem 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            margin-bottom: 3rem;
        }

        .hero-title {
            font-size: 3rem;
            font-weight: bold;
            margin-bottom: 1rem;
        }

        .hero-subtitle {
            font-size: 1.2rem;
            margin-bottom: 2rem;
            opacity: 0.9;
        }

        .hero-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn-lg {
            padding: 1rem 2rem;
            font-size: 1.1rem;
        }

        .btn-block {
            width: 100%;
        }

        .feature-card {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            height: 100%;
            transition: transform 0.3s ease;
        }

        .feature-card:hover {
            transform: translateY(-10px);
        }

        .feature-icon {
            color: #3498db;
            margin-bottom: 1rem;
        }

        .feature-card h3 {
            color: #2c3e50;
            margin-bottom: 1rem;
        }

        .stats-section .stat-card {
            text-align: center;
            padding: 2rem;
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            border-left: 4px solid #3498db;
        }

        .stat-icon {
            color: #3498db;
            margin-bottom: 1rem;
        }

        .footer-links {
            list-style: none;
            padding: 0;
        }

        .footer-links li {
            margin-bottom: 0.5rem;
        }

        .footer-links a {
            color: white;
            text-decoration: none;
        }

        .footer-links a:hover {
            text-decoration: underline;
        }

        .dashboard-header {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            text-align: center;
        }

        .dashboard-header h2 {
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }

        .dashboard-header p {
            color: #7f8c8d;
            font-size: 1.1rem;
        }

        @media (max-width: 768px) {
            .hero-title {
                font-size: 2rem;
            }
            
            .hero-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .btn-lg {
                width: 100%;
                max-width: 300px;
            }
        }
    </style>
</body>
</html>