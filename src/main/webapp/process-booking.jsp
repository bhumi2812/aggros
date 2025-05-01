<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pesticides.model.Order, com.pesticides.model.OrderItem" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <title>Order Confirmation - Agro's</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <style>
        .confirmation-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 2rem;
        }
        .order-details {
            background-color: #f8f9fa;
            padding: 1.5rem;
            border-radius: 0.5rem;
            margin-bottom: 2rem;
        }
        .order-items {
            background-color: #fff;
            padding: 1.5rem;
            border-radius: 0.5rem;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .order-item {
            border-bottom: 1px solid #eee;
            padding: 1rem 0;
        }
        .order-item:last-child {
            border-bottom: none;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="container mt-4">
        <div class="confirmation-container">
            <div class="card">
                <div class="card-header bg-success text-white">
                    <h3 class="mb-0">
                        <i class="fas fa-check-circle me-2"></i>Order Confirmed
                    </h3>
                </div>
                <div class="card-body">
                    <%
                    Order order = (Order) session.getAttribute("currentOrder");
                    if (order == null) {
                    %>
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle me-2"></i>No order found. Please try placing your order again.
                        </div>
                    <%
                    } else {
                        SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy HH:mm");
                    %>
                        <div class="order-details">
                            <h4 class="mb-4">Order Details</h4>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <p><strong>Order ID:</strong> #<%= order.getId() %></p>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <p><strong>Order Date:</strong> <%= dateFormat.format(order.getOrderDate()) %></p>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <p><strong>Status:</strong> <span class="badge bg-primary"><%= order.getStatus() %></span></p>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <p><strong>Total Amount:</strong> ₹<%= String.format("%.2f", order.getTotalAmount()) %></p>
                                </div>
                            </div>
                            
                            <h4 class="mb-4">Shipping Details</h4>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <p><strong>Name:</strong> <%= order.getShippingName() %></p>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <p><strong>Email:</strong> <%= order.getShippingEmail() %></p>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <p><strong>Phone:</strong> <%= order.getShippingPhone() != null && !order.getShippingPhone().isEmpty() ? order.getShippingPhone() : "Not provided" %></p>
                                </div>
                                <div class="col-md-12 mb-3">
                                    <p><strong>Address:</strong> <%= order.getShippingAddress() %></p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="order-items">
                            <h4 class="mb-4">Order Items</h4>
                            <div class="list-group mb-3">
                                <% for (OrderItem item : order.getItems()) { %>
                                    <div class="order-item">
                                        <div class="row align-items-center">
                                            <div class="col-6">
                                                <h6 class="mb-1"><%= item.getProduct().getName() %></h6>
                                                <p class="text-muted mb-0">Qty: <%= item.getQuantity() %></p>
                                            </div>
                                            <div class="col-6 text-end">
                                                <p class="mb-0">₹<%= String.format("%.2f", item.getPrice() * item.getQuantity()) %></p>
                                            </div>
                                        </div>
                                    </div>
                                <% } %>
                            </div>
                            
                            <div class="border-top pt-3">
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Subtotal:</span>
                                    <span>₹<%= String.format("%.2f", order.getTotalAmount()) %></span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Shipping:</span>
                                    <span>Free</span>
                                </div>
                                <div class="d-flex justify-content-between fw-bold">
                                    <span>Total:</span>
                                    <span>₹<%= String.format("%.2f", order.getTotalAmount()) %></span>
                                </div>
                            </div>
                        </div>
                        
                        <div class="text-center mt-4">
                            <a href="products.jsp" class="btn btn-primary">
                                <i class="fas fa-shopping-bag me-2"></i>Continue Shopping
                            </a>
                        </div>
                    <%
                    }
                    %>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 