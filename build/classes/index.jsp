<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Agro's - Home</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }
        .nav {
            background-color: #4CAF50;
            padding: 15px;
            text-align: center;
        }
        .nav a {
            color: white;
            text-decoration: none;
            margin: 0 15px;
            font-size: 18px;
        }
        .nav a:hover {
            text-decoration: underline;
        }
        .container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .hero-section {
            text-align: center;
            padding: 50px 0;
            background-color: #e8f5e9;
            border-radius: 5px;
            margin-bottom: 30px;
        }
        .hero-section h1 {
            color: #2e7d32;
            font-size: 2.5em;
            margin-bottom: 20px;
        }
        .hero-section p {
            color: #1b5e20;
            font-size: 1.2em;
            max-width: 800px;
            margin: 0 auto;
        }
        .cta-buttons {
            margin-top: 30px;
        }
        .cta-btn {
            display: inline-block;
            padding: 12px 25px;
            background-color: #4CAF50;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin: 0 10px;
            font-size: 16px;
        }
        .cta-btn:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="nav">
        <a href="index.jsp">Home</a>
        <a href="products.jsp">Products</a>
        <a href="cart.jsp">Cart</a>
        <a href="login.jsp">Login</a>
        <a href="admin/login.jsp">Admin Login</a>
    </div>

    <div class="container">
        <div class="hero-section">
            <h1>Welcome to Agro's</h1>
            <p>Your one-stop shop for all agricultural needs. We provide high-quality products to help you grow better.</p>
            <div class="cta-buttons">
                <a href="products.jsp" class="cta-btn">Browse Products</a>
                <a href="login.jsp" class="cta-btn">Login to Shop</a>
            </div>
        </div>
    </div>
</body>
</html> 