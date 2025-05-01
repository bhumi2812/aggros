<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pesticides.model.User, com.pesticides.model.Cart, com.pesticides.model.CartItem" %>
<!DOCTYPE html>
<html>
<head>
    <title>Order Confirmation - Agros Pesticides</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <style>
        .confirmation-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 2rem;
        }
        .success-icon {
            font-size: 4rem;
            color: #28a745;
            margin-bottom: 1rem;
        }
        .order-details {
            background-color: #f8f9fa;
            padding: 1.5rem;
            border-radius: 0.5rem;
            margin: 2rem 0;
        }
        .order-item {
            border-bottom: 1px solid #dee2e6;
            padding: 1rem 0;
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
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="container mt-4">
        <div class="confirmation-container text-center">
            <%
            User user = (User) session.getAttribute("user");
            Cart cart = (Cart) session.getAttribute("cart");
            
            if (cart == null || cart.getItems().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cart.jsp");
                return;
            }
            %>
            
            <div class="success-icon">
                <i class="fas fa-check-circle"></i>
            </div>
            
            <h2 class="mb-4">Order Confirmed!</h2>
            <p class="lead mb-4">Thank you for your purchase. Your order has been successfully placed.</p>
            
            <div class="order-details">
                <h4 class="mb-4">Order Details</h4>
                
                <div class="row mb-4">
                    <div class="col-md-6">
                        <p><strong>Order Number:</strong> #<%= System.currentTimeMillis() %></p>
                        <p><strong>Date:</strong> <%= new java.util.Date() %></p>
                    </div>
                    <div class="col-md-6">
                        <p><strong>Customer:</strong> <%= user != null ? user.getUsername() : "Guest User" %></p>
                        <p><strong>Email:</strong> <%= user != null ? user.getEmail() : "Not provided" %></p>
                    </div>
                </div>
                
                <h5 class="mb-3">Items Ordered</h5>
                <div class="list-group mb-4">
                    <% for (Cart.CartItem item : cart.getItems()) { %>
                        <div class="order-item">
                            <div class="row align-items-center">
                                <div class="col-2">
                                    <img src="<%= item.getProduct().getImageUrl() != null ? item.getProduct().getImageUrl() : "images/default-product.jpg" %>" 
                                         alt="<%= item.getProduct().getName() %>" 
                                         class="product-image">
                                </div>
                                <div class="col-6">
                                    <h6 class="mb-1"><%= item.getProduct().getName() %></h6>
                                    <p class="text-muted mb-0">Qty: <%= item.getQuantity() %></p>
                                </div>
                                <div class="col-4 text-end">
                                    <p class="mb-0">₹<%= String.format("%.2f", item.getProduct().getPrice() * item.getQuantity()) %></p>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
                
                <div class="border-top pt-3">
                    <div class="d-flex justify-content-between mb-2">
                        <span>Subtotal:</span>
                        <span>₹<%= String.format("%.2f", cart.getTotalAmount()) %></span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Shipping:</span>
                        <span>Free</span>
                    </div>
                    <div class="d-flex justify-content-between fw-bold">
                        <span>Total:</span>
                        <span>₹<%= String.format("%.2f", cart.getTotalAmount()) %></span>
                    </div>
                </div>
            </div>
            
            <div class="d-grid gap-2 col-md-6 mx-auto">
                <a href="products.jsp" class="btn btn-primary">
                    <i class="fas fa-shopping-bag me-2"></i>Continue Shopping
                </a>
                <a href="orders.jsp" class="btn btn-outline-secondary">
                    <i class="fas fa-list me-2"></i>View All Orders
                </a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 