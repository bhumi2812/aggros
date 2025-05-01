<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pesticides.model.CartItem" %>
<%@ page import="com.pesticides.model.Product" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cart - Fertilizer Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .cart-item {
            margin-bottom: 20px;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .product-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
        }
        .quantity-input {
            width: 70px;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="container mt-4">
        <h2 class="mb-4">Your Cart</h2>
        
        <%
            List<CartItem> cart = (List<CartItem>) request.getAttribute("cart");
            double total = 0.0;
            
            if (cart == null || cart.isEmpty()) {
        %>
            <div class="alert alert-info">
                Your cart is empty. <a href="products">Continue shopping</a>
            </div>
        <%
            } else {
        %>
            <div class="row">
                <div class="col-md-8">
                    <%
                        for (CartItem item : cart) {
                            Product product = item.getProduct();
                            double itemTotal = product.getPrice() * item.getQuantity();
                            total += itemTotal;
                    %>
                        <div class="card mb-3">
                            <div class="row g-0">
                                <div class="col-md-4">
                                    <img src="<%= product.getImageUrl() %>" class="img-fluid rounded-start" alt="<%= product.getName() %>">
                                </div>
                                <div class="col-md-8">
                                    <div class="card-body">
                                        <h5 class="card-title"><%= product.getName() %></h5>
                                        <p class="card-text"><%= product.getDescription() %></p>
                                        <p class="card-text">
                                            <small class="text-muted">Price: $<%= product.getPrice() %></small>
                                        </p>
                                        <form action="cart" method="post" class="d-inline">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="productId" value="<%= product.getId() %>">
                                            <div class="input-group mb-3" style="width: 200px;">
                                                <input type="number" name="quantity" value="<%= item.getQuantity() %>" 
                                                       min="1" max="<%= product.getStock() %>" class="form-control">
                                                <button type="submit" class="btn btn-outline-primary">Update</button>
                                            </div>
                                        </form>
                                        <form action="cart" method="post" class="d-inline">
                                            <input type="hidden" name="action" value="remove">
                                            <input type="hidden" name="productId" value="<%= product.getId() %>">
                                            <button type="submit" class="btn btn-outline-danger">Remove</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <%
                        }
                    %>
                </div>
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Order Summary</h5>
                            <p class="card-text">Total Items: <%= cart.size() %></p>
                            <p class="card-text">Total Amount: $<%= String.format("%.2f", total) %></p>
                            <form action="cart" method="post">
                                <input type="hidden" name="action" value="clear">
                                <button type="submit" class="btn btn-outline-danger mb-2">Clear Cart</button>
                            </form>
                            <a href="checkout.jsp" class="btn btn-primary">Proceed to Checkout</a>
                        </div>
                    </div>
                </div>
            </div>
        <%
            }
        %>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 