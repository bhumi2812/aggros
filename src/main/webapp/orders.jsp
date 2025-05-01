<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pesticides.model.Order" %>
<%@ page import="com.pesticides.model.OrderItem" %>
<%@ page import="com.pesticides.model.Product" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Orders - Agro's</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <style>
        .order-card {
            margin-bottom: 1.5rem;
            border: 1px solid #dee2e6;
            border-radius: 0.5rem;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
        }
        .order-header {
            background-color: #f8f9fa;
            padding: 1rem;
            border-bottom: 1px solid #dee2e6;
        }
        .order-item {
            padding: 1rem;
            border-bottom: 1px solid #dee2e6;
        }
        .order-item:last-child {
            border-bottom: none;
        }
        .product-image {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 0.25rem;
        }
        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 0.25rem;
            font-weight: 500;
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
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="container mt-4">
        <h1 class="mb-4">My Orders</h1>
        
        <%
        // Check if user is logged in
        if (session.getAttribute("user") == null) {
        %>
            <div class="alert alert-warning">
                <i class="fas fa-exclamation-triangle me-2"></i>Please <a href="login.jsp" class="alert-link">login</a> to view your orders.
            </div>
        <%
        } else {
            List<Order> orders = (List<Order>) request.getAttribute("orders");
            if (orders == null || orders.isEmpty()) {
        %>
                <div class="alert alert-info">
                    <i class="fas fa-shopping-bag me-2"></i>You haven't placed any orders yet.
                    <a href="products.jsp" class="alert-link">Start shopping</a>
                </div>
        <%
            } else {
                for (Order order : orders) {
        %>
                    <div class="order-card">
                        <div class="order-header">
                            <div class="row align-items-center">
                                <div class="col-md-6">
                                    <h5 class="mb-0">Order #<%= order.getId() %></h5>
                                    <small class="text-muted">Placed on <%= new SimpleDateFormat("MMMM dd, yyyy").format(order.getOrderDate()) %></small>
                                </div>
                                <div class="col-md-6 text-md-end">
                                    <span class="status-badge status-<%= order.getStatus().toLowerCase() %>">
                                        <%= order.getStatus() %>
                                    </span>
                                </div>
                            </div>
                        </div>
                        
                        <div class="order-body">
                            <%
                            for (OrderItem item : order.getItems()) {
                                Product product = item.getProduct();
                                if (product != null) {
                            %>
                                <div class="order-item">
                                    <div class="row align-items-center">
                                        <div class="col-2">
                                            <img src="<%= product.getImageUrl() != null ? product.getImageUrl() : "images/default-product.jpg" %>"
                                                 class="product-image" 
                                                 alt="<%= product.getName() %>">
                                        </div>
                                        <div class="col-6">
                                            <h6 class="mb-1"><%= product.getName() %></h6>
                                            <p class="text-muted small mb-0"><%= product.getDescription() %></p>
                                        </div>
                                        <div class="col-2 text-center">
                                            <span class="text-muted">Qty: <%= item.getQuantity() %></span>
                                        </div>
                                        <div class="col-2 text-end">
                                            <span class="text-primary">$<%= String.format("%.2f", item.getPrice() * item.getQuantity()) %></span>
                                        </div>
                                    </div>
                                </div>
                            <% 
                                }
                            }
                            %>
                            
                            <div class="order-footer p-3 bg-light">
                                <div class="row">
                                    <div class="col-md-6">
                                        <h6 class="mb-2">Shipping Address</h6>
                                        <p class="mb-0"><%= order.getShippingAddress() %></p>
                                    </div>
                                    <div class="col-md-6 text-md-end">
                                        <h6 class="mb-2">Order Total</h6>
                                        <h5 class="text-primary mb-0">$<%= String.format("%.2f", order.getTotalAmount()) %></h5>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
        <% 
                }
            }
        }
        %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

 