<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pesticides.model.Order" %>
<%@ page import="com.pesticides.model.OrderItem" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Orders - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .container {
            max-width: 1200px;
            margin-top: 30px;
        }
        .card {
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .order-header {
            background-color: #f8f9fa;
            padding: 15px;
            border-bottom: 1px solid #dee2e6;
        }
        .order-items {
            padding: 15px;
        }
        .order-item {
            display: flex;
            align-items: center;
            padding: 10px;
            border-bottom: 1px solid #dee2e6;
        }
        .order-item:last-child {
            border-bottom: none;
        }
        .product-image {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 5px;
            margin-right: 15px;
        }
        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: bold;
        }
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }
        .status-processing {
            background-color: #cce5ff;
            color: #004085;
        }
        .status-shipped {
            background-color: #d4edda;
            color: #155724;
        }
        .status-delivered {
            background-color: #d1ecf1;
            color: #0c5460;
        }
        .status-cancelled {
            background-color: #f8d7da;
            color: #721c24;
        }
        .alert {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <jsp:include page="../header.jsp" />
    
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Manage Orders</h2>
            <div class="btn-group">
                <a href="orders?status=all" class="btn btn-outline-primary">All</a>
                <a href="orders?status=pending" class="btn btn-outline-warning">Pending</a>
                <a href="orders?status=processing" class="btn btn-outline-info">Processing</a>
                <a href="orders?status=shipped" class="btn btn-outline-success">Shipped</a>
                <a href="orders?status=delivered" class="btn btn-outline-secondary">Delivered</a>
                <a href="orders?status=cancelled" class="btn btn-outline-danger">Cancelled</a>
            </div>
        </div>
        
        <%
            String error = (String) request.getAttribute("error");
            String success = (String) request.getAttribute("success");
            
            if (error != null) {
        %>
            <div class="alert alert-danger" role="alert">
                <%= error %>
            </div>
        <%
            }
            if (success != null) {
        %>
            <div class="alert alert-success" role="alert">
                <%= success %>
            </div>
        <%
            }
        %>
        
        <%
            List<Order> orders = (List<Order>) request.getAttribute("orders");
            if (orders != null && !orders.isEmpty()) {
                SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy HH:mm");
                for (Order order : orders) {
        %>
            <div class="card">
                <div class="order-header">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h5 class="mb-0">Order #<%= order.getId() %></h5>
                            <small class="text-muted">
                                Placed by <%= order.getUser().getUsername() %> on 
                                <%= dateFormat.format(order.getOrderDate()) %>
                            </small>
                        </div>
                        <div>
                            <span class="status-badge status-<%= order.getStatus().toLowerCase() %>">
                                <%= order.getStatus() %>
                            </span>
                        </div>
                    </div>
                </div>
                
                <div class="order-items">
                    <%
                        for (OrderItem item : order.getItems()) {
                    %>
                        <div class="order-item">
                            <img src="<%= item.getProduct().getImageUrl() %>" 
                                 alt="<%= item.getProduct().getName() %>" 
                                 class="product-image">
                            <div class="flex-grow-1">
                                <h6 class="mb-0"><%= item.getProduct().getName() %></h6>
                                <small class="text-muted">
                                    Quantity: <%= item.getQuantity() %> × ₹<%= String.format("%.2f", item.getPrice()) %>
                                </small>
                            </div>
                            <div class="text-end">
                                <strong>₹<%= String.format("%.2f", item.getQuantity() * item.getPrice()) %></strong>
                            </div>
                        </div>
                    <%
                        }
                    %>
                    
                    <div class="order-item">
                        <div class="flex-grow-1 text-end">
                            <strong>Total Amount: ₹<%= String.format("%.2f", order.getTotalAmount()) %></strong>
                        </div>
                    </div>
                    
                    <div class="mt-3">
                        <form action="orders" method="post" class="d-flex justify-content-end gap-2">
                            <input type="hidden" name="orderId" value="<%= order.getId() %>">
                            <select name="status" class="form-select" style="width: auto;">
                                <option value="pending" <%= order.getStatus().equals("Pending") ? "selected" : "" %>>Pending</option>
                                <option value="processing" <%= order.getStatus().equals("Processing") ? "selected" : "" %>>Processing</option>
                                <option value="shipped" <%= order.getStatus().equals("Shipped") ? "selected" : "" %>>Shipped</option>
                                <option value="delivered" <%= order.getStatus().equals("Delivered") ? "selected" : "" %>>Delivered</option>
                                <option value="cancelled" <%= order.getStatus().equals("Cancelled") ? "selected" : "" %>>Cancelled</option>
                            </select>
                            <button type="submit" class="btn btn-primary">Update Status</button>
                        </form>
                    </div>
                </div>
            </div>
        <%
                }
            } else {
        %>
            <div class="alert alert-info">No orders found.</div>
        <%
            }
        %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 