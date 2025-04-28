<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.fertilizer.model.CartItem, com.fertilizer.model.Product, com.fertilizer.dao.ProductDAO, com.fertilizer.model.User, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cart");
    ProductDAO productDAO = new ProductDAO();
    double total = 0.0;
    String paymentMethod = request.getParameter("method");
    
    // Calculate total
    if (cartItems != null && !cartItems.isEmpty()) {
        for (CartItem item : cartItems) {
            Product product = productDAO.getProductById(item.getProduct().getId());
            if (product != null) {
                total += product.getPrice() * item.getQuantity();
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment - Agro's</title>
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
        
        .payment-container {
            display: flex;
            gap: 30px;
            margin-top: 20px;
        }
        
        .payment-details {
            flex: 1;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .order-summary {
            flex: 1;
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
        
        .payment-method {
            margin-bottom: 20px;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        
        .payment-method img {
            width: 40px;
            height: 40px;
            margin-right: 15px;
            vertical-align: middle;
        }
        
        .qr-container {
            text-align: center;
            margin: 30px 0;
        }
        
        .qr-code {
            width: 200px;
            height: 200px;
            margin: 0 auto;
            border: 1px solid #ddd;
            padding: 10px;
            border-radius: 5px;
        }
        
        .btn {
            background-color: #4CAF50;
            color: white;
            padding: 12px 24px;
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
        
        /* Success Modal Styles */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            z-index: 1000;
        }
        
        .modal-content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            padding: 30px;
            border-radius: 10px;
            text-align: center;
            max-width: 400px;
            width: 90%;
        }
        
        .modal-icon {
            font-size: 48px;
            color: #4CAF50;
            margin-bottom: 20px;
        }
        
        .modal-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 20px;
        }
        
        .modal-btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
        }
        
        .modal-btn-primary {
            background-color: #4CAF50;
            color: white;
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
        <div class="payment-container">
            <div class="payment-details">
                <h2 class="section-title">Payment Details</h2>
                
                <div class="payment-method">
                    <% if ("card".equals(paymentMethod)) { %>
                        <img src="images/credit-card.png" alt="Credit Card">
                        <span>Credit/Debit Card Payment</span>
                    <% } else if ("upi".equals(paymentMethod)) { %>
                        <img src="images/upi.png" alt="UPI">
                        <span>UPI Payment</span>
                    <% } %>
                </div>
                
                <div class="qr-container">
                    <h3>Scan QR Code to Pay</h3>
                    <img src="images/qr-code.png" alt="Payment QR Code" class="qr-code">
                    <p>Amount to Pay: ₹<%= total %></p>
                </div>
                
                <button type="button" class="btn" onclick="showSuccessModal()">Proceed to Pay</button>
            </div>
            
            <div class="order-summary">
                <h2 class="section-title">Order Summary</h2>
                
                <% if (cartItems != null && !cartItems.isEmpty()) { %>
                    <% for (CartItem item : cartItems) { 
                        Product product = productDAO.getProductById(item.getProduct().getId());
                        if (product != null) {
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
            </div>
        </div>
    </div>
    
    <!-- Success Modal -->
    <div id="successModal" class="modal">
        <div class="modal-content">
            <div class="modal-icon">✓</div>
            <h2>Payment Successful!</h2>
            <p>Thank you for your payment. Your order has been confirmed.</p>
            <div class="modal-buttons">
                <a href="order-details.jsp" class="modal-btn modal-btn-primary">View Order Details</a>
            </div>
        </div>
    </div>
    
    <script>
        function showSuccessModal() {
            // Show success modal
            document.getElementById('successModal').style.display = 'block';
            
            // Redirect to order details page after 2 seconds
            setTimeout(function() {
                window.location.href = 'order-details.jsp';
            }, 2000);
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            var modal = document.getElementById('successModal');
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        }
    </script>
</body>
</html> 