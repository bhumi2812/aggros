<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error - Fertilizer Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .error-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
        }
        .error-icon {
            font-size: 5rem;
            color: #dc3545;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="error-container">
        <div class="container">
            <i class="fas fa-exclamation-circle error-icon"></i>
            <h1 class="display-4">Oops! Something went wrong</h1>
            <p class="lead">We're sorry, but there was an error processing your request.</p>
            <%
                String errorCode = request.getAttribute("jakarta.servlet.error.status_code") != null ? 
                    request.getAttribute("jakarta.servlet.error.status_code").toString() : "Unknown";
                String errorMessage = request.getAttribute("jakarta.servlet.error.message") != null ? 
                    request.getAttribute("jakarta.servlet.error.message").toString() : "An unexpected error occurred";
            %>
            <div class="alert alert-danger mt-4">
                <h5>Error Details:</h5>
                <p>Error Code: <%= errorCode %></p>
                <p>Error Message: <%= errorMessage %></p>
            </div>
            <div class="mt-4">
                <a href="home.jsp" class="btn btn-primary me-2">Go to Home</a>
                <a href="products" class="btn btn-success">Continue Shopping</a>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/js/all.min.js"></script>
</body>
</html> 