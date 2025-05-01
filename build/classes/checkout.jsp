<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pesticides.model.CartItem, com.pesticides.model.Product, com.pesticides.dao.ProductDAO, com.pesticides.model.User, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cart");
    ProductDAO productDAO = new ProductDAO();
    double total = 0.0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Agro's - Checkout</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }
        
        body {
            background-color: #f5f5f5;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .nav-menu {
            background-color: #4CAF50;
            padding: 15px 0;
            margin-bottom: 30px;
        }
        
        .nav-menu ul {
            list-style: none;
            display: flex;
            justify-content: center;
            gap: 20px;
        }
        
        .nav-menu a {
            color: white;
            text-decoration: none;
            font-weight: bold;
            padding: 10px 15px;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        
        .nav-menu a:hover {
            background-color: #45a049;
        }
        
        .checkout-container {
            display: flex;
            gap: 30px;
            margin-top: 20px;
        }
        
        .address-section {
            flex: 1;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .cart-summary {
            flex: 1;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        
        input[type="text"],
        input[type="tel"],
        textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }
        
        textarea {
            height: 100px;
            resize: vertical;
        }
        
        .btn {
            background-color: #4CAF50;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
            margin-top: 20px;
        }
        
        .btn:hover {
            background-color: #45a049;
        }
        
        .btn-edit {
            background-color: #2196F3;
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            margin-top: 10px;
        }
        
        .btn-edit:hover {
            background-color: #1976D2;
        }
        
        .order-item {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .order-item img {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 5px;
            margin-right: 15px;
        }
        
        .order-item-details {
            flex: 1;
        }
        
        .order-item-name {
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .order-item-price {
            color: #4CAF50;
            font-weight: bold;
        }
        
        .order-total {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 2px solid #eee;
            text-align: right;
        }
        
        .total-amount {
            font-size: 24px;
            color: #4CAF50;
            font-weight: bold;
        }
        
        .error-message {
            color: #f44336;
            margin-bottom: 20px;
            padding: 10px;
            background-color: #ffebee;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <div class="nav-menu">
        <ul>
            <li><a href="index.jsp">Home</a></li>
            <li><a href="products.jsp">Products</a></li>
            <li><a href="cart.jsp">Cart</a></li>
            <li><a href="orders.jsp">Orders</a></li>
            <li><a href="logout">Logout</a></li>
        </ul>
    </div>
    
    <div class="container">
        <div class="checkout-container">
            <div class="address-section">
                <h2>Shipping Address</h2>
                <% if (user.getAddress() != null && !user.getAddress().trim().isEmpty()) { %>
                    <div class="current-address">
                        <p><strong>Name:</strong> <%= user.getName() %></p>
                        <p><strong>Phone:</strong> <%= user.getPhone() %></p>
                        <p><strong>Address:</strong> <%= user.getAddress() %></p>
                        <button class="btn-edit" onclick="showAddressForm()">Edit Address</button>
                    </div>
                    
                    <form id="addressForm" action="checkout" method="post" style="display: none;">
                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <input type="tel" id="phone" name="phone" value="<%= user.getPhone() %>" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="address">Delivery Address</label>
                            <textarea id="address" name="address" required><%= user.getAddress() %></textarea>
                        </div>
                        
                        <button type="submit" class="btn">Update Address</button>
                    </form>
                <% } else { %>
                    <form action="checkout" method="post">
                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <input type="tel" id="phone" name="phone" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="address">Delivery Address</label>
                            <textarea id="address" name="address" required></textarea>
                        </div>
                        
                        <button type="submit" class="btn">Save Address</button>
                    </form>
                <% } %>
                
                <% if (request.getAttribute("error") != null) { %>
                    <div class="error-message">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>
            </div>
            
            <div class="cart-summary">
                <h2>Order Summary</h2>
                <% if (cartItems != null && !cartItems.isEmpty()) { %>
                    <% for (CartItem item : cartItems) { 
                        Product product = productDAO.getProductById(item.getProduct().getId());
                        if (product != null) {
                            total += product.getPrice() * item.getQuantity();
                    %>
                        <div class="order-item">
                            <img src="<%= product.getImageUrl() %>" alt="<%= product.getName() %>">
                            <div class="order-item-details">
                                <div class="order-item-name"><%= product.getName() %></div>
                                <div>Quantity: <%= item.getQuantity() %></div>
                                <div class="order-item-price">₹<%= product.getPrice() * item.getQuantity() %></div>
                            </div>
                        </div>
                    <% }} %>
                    <div class="order-total">
                        <div>Total Amount:</div>
                        <div class="total-amount">₹<%= total %></div>
                    </div>
                    
                    <% if (user.getAddress() != null && !user.getAddress().trim().isEmpty()) { %>
                        <a href="booking.jsp" class="btn">Proceed to Payment</a>
                    <% } %>
                <% } else { %>
                    <p>Your cart is empty</p>
                <% } %>
            </div>
        </div>
    </div>
    
    <script>
        function showAddressForm() {
            document.querySelector('.current-address').style.display = 'none';
            document.getElementById('addressForm').style.display = 'block';
        }
    </script>
</body>
</html> 