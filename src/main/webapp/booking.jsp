<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pesticides.model.Cart" %>
<%@ page import="com.pesticides.model.Cart.CartItem" %>
<%@ page import="com.pesticides.model.Product" %>
<%@ page import="com.pesticides.model.User" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Place Order - Agro's</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <style>
        .booking-container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .order-summary {
            background-color: #f8f9fa;
            padding: 1.5rem;
            border-radius: 0.5rem;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
        }
        .cart-item {
            margin-bottom: 1rem;
            padding: 1rem;
            border: 1px solid #dee2e6;
            border-radius: 0.25rem;
        }
        .cart-item-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 0.25rem;
        }
        .form-control:focus {
            box-shadow: none;
            border-color: #0d6efd;
        }
        .confirmation-modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            z-index: 1000;
        }
        .confirmation-content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            padding: 2rem;
            border-radius: 0.5rem;
            max-width: 500px;
            width: 90%;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="container mt-4">
        <h1 class="mb-4">Place Order</h1>
        
        <%
        // Check if user is logged in
        User user = (User) session.getAttribute("user");
        if (user == null) {
        %>
            <div class="alert alert-warning">
                <i class="fas fa-exclamation-triangle me-2"></i>Please <a href="login.jsp" class="alert-link">login</a> to place your order.
            </div>
        <%
        } else {
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null || cart.getTotalItems() == 0) {
        %>
                <div class="alert alert-info">
                    <i class="fas fa-shopping-cart me-2"></i>Your cart is empty. 
                    <a href="products.jsp" class="alert-link">Continue shopping</a>
                </div>
        <%
            } else {
                List<Cart.CartItem> items = cart.getItems();
        %>
                <div class="row">
                    <!-- Shipping Details -->
                    <div class="col-md-8">
                        <div class="card mb-4">
                            <div class="card-header">
                                <h5 class="mb-0">Shipping Details</h5>
                            </div>
                            <div class="card-body">
                                <form id="orderForm" action="process-booking" method="post">
                                    <div class="mb-3">
                                        <label for="name" class="form-label">Full Name</label>
                                        <input type="text" class="form-control" id="name" name="name" value="<%= user.getName() %>" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="email" class="form-label">Email</label>
                                        <input type="email" class="form-control" id="email" name="email" value="<%= user.getEmail() %>" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="phone" class="form-label">Phone Number</label>
                                        <input type="tel" class="form-control" id="phone" name="phone" value="<%= user.getPhone() %>" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="address" class="form-label">Shipping Address</label>
                                        <textarea class="form-control" id="address" name="address" rows="3" required><%= user.getAddress() %></textarea>
                                    </div>
                                    
                                    <div class="d-grid">
                                        <button type="button" class="btn btn-primary btn-lg" onclick="confirmOrder()">
                                            <i class="fas fa-shopping-bag me-2"></i>Place Order
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Order Summary -->
                    <div class="col-md-4">
                        <div class="order-summary">
                            <h4 class="mb-3">Order Summary</h4>
                            <hr>
                            
                            <!-- Cart Items -->
                            <div class="mb-3">
                                <% for (Cart.CartItem item : items) { 
                                    if (item != null && item.getProduct() != null) {
                                        Product product = item.getProduct();
                                %>
                                    <div class="cart-item">
                                        <div class="row align-items-center">
                                            <div class="col-3">
                                                <img src="<%= product.getImageUrl() != null ? product.getImageUrl() : "images/default-product.jpg" %>"
                                                     class="cart-item-image" 
                                                     alt="<%= product.getName() %>">
                                            </div>
                                            <div class="col-9">
                                                <h6 class="mb-1"><%= product.getName() %></h6>
                                                <div class="d-flex justify-content-between">
                                                    <span class="text-muted">Qty: <%= item.getQuantity() %></span>
                                                    <span class="text-primary">$<%= String.format("%.2f", product.getPrice() * item.getQuantity()) %></span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                <% } } %>
                            </div>
                            
                            <hr>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Subtotal:</span>
                                <span class="text-primary">$<%= String.format("%.2f", cart.getTotalAmount()) %></span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Shipping:</span>
                                <span class="text-success">Free</span>
                            </div>
                            <hr>
                            <div class="d-flex justify-content-between mb-3">
                                <span class="h5">Total:</span>
                                <span class="h5 text-primary">$<%= String.format("%.2f", cart.getTotalAmount()) %></span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Order Confirmation Modal -->
                <div id="confirmationModal" class="confirmation-modal">
                    <div class="confirmation-content">
                        <div class="text-center mb-4">
                            <i class="fas fa-check-circle text-success" style="font-size: 3rem;"></i>
                            <h3 class="mt-3">Confirm Your Order</h3>
                        </div>
                        
                        <div class="mb-4">
                            <h5>Order Summary</h5>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Total Items:</span>
                                <span><%= cart.getTotalItems() %></span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span>Total Amount:</span>
                                <span class="text-primary">$<%= String.format("%.2f", cart.getTotalAmount()) %></span>
                            </div>
                        </div>
                        
                        <div class="mb-4">
                            <h5>Shipping Details</h5>
                            <p class="mb-1"><strong>Name:</strong> <span id="confirmName"></span></p>
                            <p class="mb-1"><strong>Email:</strong> <span id="confirmEmail"></span></p>
                            <p class="mb-1"><strong>Phone:</strong> <span id="confirmPhone"></span></p>
                            <p class="mb-0"><strong>Address:</strong> <span id="confirmAddress"></span></p>
                        </div>
                        
                        <div class="d-grid gap-2">
                            <button type="button" class="btn btn-primary" onclick="submitOrder()">
                                <i class="fas fa-check me-2"></i>Confirm Order
                            </button>
                            <button type="button" class="btn btn-outline-secondary" onclick="closeModal()">
                                <i class="fas fa-times me-2"></i>Cancel
                            </button>
                        </div>
                    </div>
                </div>
        <% 
            }
        }
        %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmOrder() {
            // Get form values
            const name = document.getElementById('name').value;
            const email = document.getElementById('email').value;
            const phone = document.getElementById('phone').value;
            const address = document.getElementById('address').value;
            
            // Validate form
            if (!name || !email || !phone || !address) {
                alert('Please fill in all required fields');
                return;
            }
            
            // Update confirmation modal
            document.getElementById('confirmName').textContent = name;
            document.getElementById('confirmEmail').textContent = email;
            document.getElementById('confirmPhone').textContent = phone;
            document.getElementById('confirmAddress').textContent = address;
            
            // Show modal
            document.getElementById('confirmationModal').style.display = 'block';
        }
        
        function closeModal() {
            document.getElementById('confirmationModal').style.display = 'none';
        }
        
        function submitOrder() {
            document.getElementById('orderForm').submit();
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('confirmationModal');
            if (event.target == modal) {
                closeModal();
            }
        }
    </script>
</body>
</html> 