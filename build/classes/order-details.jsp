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
    <title>Order Details - Agro's</title>
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
        
        .order-details-container {
            display: flex;
            gap: 30px;
            margin-top: 20px;
        }
        
        .shipping-details {
            flex: 1;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .order-items {
            flex: 2;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .section-title {
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #4CAF50;
        }
        
        .detail-group {
            margin-bottom: 15px;
        }
        
        .detail-label {
            font-weight: bold;
            color: #666;
            margin-bottom: 5px;
        }
        
        .detail-value {
            color: #333;
        }
        
        .order-item {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .order-item img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 5px;
            margin-right: 20px;
        }
        
        .order-item-details {
            flex: 1;
        }
        
        .order-item-name {
            font-weight: bold;
            margin-bottom: 5px;
            color: #333;
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
        
        .order-status {
            background-color: #4CAF50;
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: bold;
            display: inline-block;
            margin-top: 20px;
        }
        
        .btn {
            display: inline-block;
            background-color: #4CAF50;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
            margin-top: 20px;
            transition: background-color 0.3s;
        }
        
        .btn:hover {
            background-color: #45a049;
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
        <div class="order-details-container">
            <div class="shipping-details">
                <h2 class="section-title">Order Information</h2>
                
                <div class="detail-group">
                    <div class="detail-label">Order Number</div>
                    <div class="detail-value">#<%= System.currentTimeMillis() %></div>
                </div>
                
                <div class="detail-group">
                    <div class="detail-label">Order Date</div>
                    <div class="detail-value"><%= new java.util.Date() %></div>
                </div>
                
                <div class="detail-group">
                    <div class="detail-label">Payment Method</div>
                    <div class="detail-value">Cash on Delivery</div>
                </div>
                
                <div class="detail-group">
                    <div class="detail-label">Order Status</div>
                    <div class="order-status">Processing</div>
                </div>
                
                <h2 class="section-title" style="margin-top: 30px;">Shipping Details</h2>
                
                <div class="detail-group">
                    <div class="detail-label">Name</div>
                    <div class="detail-value"><%= user.getName() %></div>
                </div>
                
                <div class="detail-group">
                    <div class="detail-label">Email</div>
                    <div class="detail-value"><%= user.getEmail() %></div>
                </div>
                
                <div class="detail-group">
                    <div class="detail-label">Phone</div>
                    <div class="detail-value"><%= user.getPhone() %></div>
                </div>
                
                <div class="detail-group">
                    <div class="detail-label">Address</div>
                    <div class="detail-value"><%= user.getAddress() %></div>
                </div>
            </div>
            
            <div class="order-items">
                <h2 class="section-title">Order Items</h2>
                
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
                <% } else { %>
                    <p>No items in this order</p>
                <% } %>
                
                <a href="products.jsp" class="btn">Continue Shopping</a>
            </div>
        </div>
    </div>
</body>
</html> 