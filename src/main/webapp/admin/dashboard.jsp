<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.fertilizer.model.Order, com.fertilizer.model.Product" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h1, h2 {
            color: #333;
            margin-bottom: 20px;
        }
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background-color: #4CAF50;
            color: white;
            padding: 20px;
            border-radius: 5px;
            text-align: center;
        }
        .stat-card h3 {
            margin: 0;
            font-size: 24px;
        }
        .stat-card p {
            margin: 10px 0 0;
            font-size: 16px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Admin Dashboard</h1>
        
        <div class="stats-container">
            <div class="stat-card">
                <h3><%= request.getAttribute("totalProducts") %></h3>
                <p>Total Products</p>
            </div>
            <div class="stat-card">
                <h3><%= request.getAttribute("totalOrders") %></h3>
                <p>Total Orders</p>
            </div>
            <div class="stat-card">
                <h3><%= request.getAttribute("pendingOrders") %></h3>
                <p>Pending Orders</p>
            </div>
        </div>

        <h2>Recent Orders</h2>
        <table>
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Customer</th>
                    <th>Product</th>
                    <th>Amount</th>
                    <th>Status</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody>
                <% 
                List<Order> recentOrders = (List<Order>)request.getAttribute("recentOrders");
                if (recentOrders != null) {
                    for (Order order : recentOrders) { 
                %>
                    <tr>
                        <td><%= order.getOrderId() %></td>
                        <td><%= order.getCustomerName() %></td>
                        <td><%= order.getProductName() %></td>
                        <td>$<%= order.getTotalAmount() %></td>
                        <td><%= order.getStatus() %></td>
                        <td><%= order.getOrderDate() %></td>
                    </tr>
                <% 
                    }
                }
                %>
            </tbody>
        </table>

        <h2>Low Stock Products</h2>
        <table>
            <thead>
                <tr>
                    <th>Product ID</th>
                    <th>Name</th>
                    <th>Category</th>
                    <th>Stock</th>
                    <th>Price</th>
                </tr>
            </thead>
            <tbody>
                <% 
                List<Product> lowStockProducts = (List<Product>)request.getAttribute("lowStockProducts");
                if (lowStockProducts != null) {
                    for (Product product : lowStockProducts) { 
                %>
                    <tr>
                        <td><%= product.getId() %></td>
                        <td><%= product.getName() %></td>
                        <td><%= product.getCategory() %></td>
                        <td><%= product.getStock() %></td>
                        <td>$<%= product.getPrice() %></td>
                    </tr>
                <% 
                    }
                }
                %>
            </tbody>
        </table>
    </div>
</body>
</html> 