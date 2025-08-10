<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Municipality Complaint System</title>
    <link rel="stylesheet" href="/static/css/style.css">
    <style>
        .error-container {
            text-align: center;
            padding: 4rem 2rem;
            max-width: 600px;
            margin: 0 auto;
        }
        
        .error-icon {
            font-size: 6rem;
            margin-bottom: 2rem;
        }
        
        .error-code {
            font-size: 4rem;
            font-weight: bold;
            color: #e74c3c;
            margin-bottom: 1rem;
        }
        
        .error-title {
            font-size: 2rem;
            color: #2c3e50;
            margin-bottom: 1rem;
        }
        
        .error-message {
            font-size: 1.1rem;
            color: #7f8c8d;
            margin-bottom: 2rem;
            line-height: 1.6;
        }
        
        .error-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .error-details {
            margin-top: 3rem;
            padding: 2rem;
            background: #f8f9fa;
            border-radius: 8px;
            text-align: left;
        }
        
        .error-details h4 {
            color: #2c3e50;
            margin-bottom: 1rem;
        }
        
        .error-details pre {
            background: #2c3e50;
            color: #ecf0f1;
            padding: 1rem;
            border-radius: 4px;
            overflow-x: auto;
            font-size: 0.9rem;
        }
        
        .home-button {
            background: #3498db;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: background-color 0.3s;
        }
        
        .home-button:hover {
            background: #2980b9;
        }
        
        .back-button {
            background: #95a5a6;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: background-color 0.3s;
        }
        
        .back-button:hover {
            background: #7f8c8d;
        }
        
        @media (max-width: 768px) {
            .error-container {
                padding: 2rem 1rem;
            }
            
            .error-icon {
                font-size: 4rem;
            }
            
            .error-code {
                font-size: 3rem;
            }
            
            .error-title {
                font-size: 1.5rem;
            }
            
            .error-actions {
                flex-direction: column;
                align-items: center;
            }
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="container">
            <div class="header-content">
                <div class="logo">
                    <h1>Municipality Complaint System</h1>
                </div>
            </div>
        </div>
    </header>

    <main class="main">
        <div class="container">
            <div class="error-container">
                <div class="error-icon">⚠️</div>
                
                <div class="error-code">
                    <c:choose>
                        <c:when test="${not empty status}">${status}</c:when>
                        <c:otherwise>404</c:otherwise>
                    </c:choose>
                </div>
                
                <div class="error-title">
                    <c:choose>
                        <c:when test="${not empty error}">${error}</c:when>
                        <c:when test="${not empty status and status == '404'}">Page Not Found</c:when>
                        <c:when test="${not empty status and status == '403'}">Access Denied</c:when>
                        <c:when test="${not empty status and status == '500'}">Internal Server Error</c:when>
                        <c:otherwise>Something went wrong</c:otherwise>
                    </c:choose>
                </div>
                
                <div class="error-message">
                    <c:choose>
                        <c:when test="${not empty message}">${message}</c:when>
                        <c:when test="${not empty status and status == '404'}">
                            The page you're looking for doesn't exist or has been moved. 
                            Please check the URL or navigate to a different page.
                        </c:when>
                        <c:when test="${not empty status and status == '403'}">
                            You don't have permission to access this resource. 
                            Please contact your administrator if you believe this is an error.
                        </c:when>
                        <c:when test="${not empty status and status == '500'}">
                            An internal server error occurred. Our team has been notified 
                            and is working to resolve the issue.
                        </c:when>
                        <c:otherwise>
                            An unexpected error occurred. Please try again later or contact support if the problem persists.
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <div class="error-actions">
                    <a href="/dashboard" class="home-button">🏠 Go to Dashboard</a>
                    <button onclick="history.back()" class="back-button">⬅️ Go Back</button>
                </div>
                
                <c:if test="${not empty exception and pageContext.request.serverName == 'localhost'}">
                    <div class="error-details">
                        <h4>Error Details (Development Mode)</h4>
                        <pre><code>${exception}</code></pre>
                        
                        <c:if test="${not empty trace}">
                            <h4>Stack Trace</h4>
                            <pre><code>${trace}</code></pre>
                        </c:if>
                    </div>
                </c:if>
            </div>
        </div>
    </main>

    <script>
        // Auto-redirect to dashboard after 10 seconds
        setTimeout(function() {
            window.location.href = '/dashboard';
        }, 10000);
        
        // Add a countdown timer
        let countdown = 10;
        const countdownElement = document.createElement('div');
        countdownElement.style.cssText = 'text-align: center; margin-top: 1rem; color: #7f8c8d; font-size: 0.9rem;';
        countdownElement.textContent = `Redirecting to dashboard in ${countdown} seconds...`;
        
        document.querySelector('.error-actions').after(countdownElement);
        
        const timer = setInterval(function() {
            countdown--;
            countdownElement.textContent = `Redirecting to dashboard in ${countdown} seconds...`;
            
            if (countdown <= 0) {
                clearInterval(timer);
                countdownElement.textContent = 'Redirecting now...';
            }
        }, 1000);
    </script>
</body>
</html>