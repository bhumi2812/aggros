<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Fertilizer E-Commerce</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        .navbar {
            background-color: #4CAF50;
            padding: 15px;
            color: white;
        }
        .navbar a {
            color: white;
            text-decoration: none;
            margin-right: 20px;
        }
        .navbar a:hover {
            text-decoration: underline;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="container">
            <a href="index.jsp">Home</a>
            <a href="products.jsp">Products</a>
            <a href="orders.jsp">Orders</a>
            <% 
            String userRole = (String)session.getAttribute("userRole");
            if (userRole != null && userRole.equals("admin")) { 
            %>
                <a href="admin/dashboard.jsp">Admin Dashboard</a>
            <% } %>
            <% if (userRole == null) { %>
                <a href="login.jsp">Login</a>
                <a href="register.jsp">Register</a>
            <% } else { %>
                <a href="logout">Logout</a>
            <% } %>
        </div>
    </div>
    <div class="container"> 