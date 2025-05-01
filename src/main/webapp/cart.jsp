<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.pesticides.model.Cart" %>
<%@ page import="com.pesticides.model.Cart.CartItem" %>
<%@ page import="com.pesticides.model.Product" %>
<!DOCTYPE html>
<html>
<head>
    <title>Cart - Agro's</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <style>
        .cart-item {
            margin-bottom: 1rem;
            padding: 1rem;
            border: 1px solid #dee2e6;
            border-radius: 0.25rem;
            transition: all 0.3s ease;
        }
        .cart-item:hover {
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        }
        .cart-item-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 0.25rem;
        }
        .quantity-input {
            width: 60px;
            text-align: center;
        }
        .quantity-input:focus {
            box-shadow: none;
            border-color: #0d6efd;
        }
        .total-section {
            background-color: #f8f9fa;
            padding: 1.5rem;
            border-radius: 0.5rem;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
        }
        .btn-update {
            padding: 0.25rem 0.5rem;
        }
        .btn-remove {
            padding: 0.25rem 0.5rem;
        }
        .empty-cart-message {
            padding: 2rem;
            text-align: center;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="container mt-4">
        <h1 class="mb-4">Shopping Cart</h1>
        
        <%
        // Get cart from session or create new one
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }
        
        // Get cart items
        List<Cart.CartItem> items = cart.getItems();
        
        // Check if cart has items
        if (items != null && !items.isEmpty()) {
        %>
            <div class="row">
                <div class="col-md-8">
                    <% 
                    // Display each cart item
                    for (Cart.CartItem item : items) {
                        if (item != null) {
                            Product product = item.getProduct();
                            if (product != null) {
                    %>
                        <div class="cart-item">
                            <div class="row align-items-center">
                                <div class="col-md-2">
                                    <img src="<%= product.getImageUrl() != null ? product.getImageUrl() : "images/default-product.jpg" %>"
                                         class="cart-item-image" 
                                         alt="<%= product.getName() %>">
                                </div>
                                <div class="col-md-4">
                                    <h5 class="mb-1"><%= product.getName() %></h5>
                                    <p class="text-muted small mb-0"><%= product.getDescription() %></p>
                                </div>
                                <div class="col-md-2">
                                    <span class="h5 text-primary">$<%= String.format("%.2f", product.getPrice()) %></span>
                                </div>
                                <div class="col-md-2">
                                    <form action="cart" method="post" class="d-flex align-items-center">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="productId" value="<%= product.getId() %>">
                                        <input type="number" name="quantity" value="<%= item.getQuantity() %>" 
                                               min="1" max="<%= product.getStock() %>"
                                               class="form-control quantity-input">
                                        <button type="submit" class="btn btn-sm btn-outline-primary btn-update ms-2">
                                            <i class="fas fa-sync"></i>
                                        </button>
                                    </form>
                                </div>
                                <div class="col-md-2">
                                    <form action="cart" method="post">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="productId" value="<%= product.getId() %>">
                                        <button type="submit" class="btn btn-danger btn-remove">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    <% 
                            }
                        }
                    } 
                    %>
                </div>
                <div class="col-md-4">
                    <div class="total-section">
                        <h4 class="mb-3">Order Summary</h4>
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
                        <div class="d-grid">
                            <a href="checkout.jsp" class="btn btn-primary btn-lg">
                                <i class="fas fa-shopping-bag me-2"></i>Proceed to Checkout
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        <% } else { %>
            <div class="empty-cart-message">
                <i class="fas fa-shopping-cart fa-3x text-muted mb-3"></i>
                <h4 class="text-muted">Your cart is empty</h4>
                <p class="text-muted">Looks like you haven't added any items to your cart yet.</p>
                <a href="products.jsp" class="btn btn-primary">
                    <i class="fas fa-store me-2"></i>Continue Shopping
                </a>
            </div>
        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
