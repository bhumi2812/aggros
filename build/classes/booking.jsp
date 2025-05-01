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
        
        .booking-container {
            display: flex;
            gap: 30px;
            margin-top: 20px;
        }
        
        .booking-form {
            flex: 2;
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
        input[type="email"],
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
        
        .payment-methods {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        
        .payment-option {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .payment-option:hover {
            border-color: #4CAF50;
            background-color: #f9f9f9;
        }
        
        .payment-option input[type="radio"] {
            margin-right: 10px;
        }
        
        .payment-icon {
            width: 40px;
            height: 40px;
            margin-right: 15px;
            object-fit: contain;
        }
        
        .payment-details {
            margin-top: 20px;
            padding: 20px;
            background-color: #f9f9f9;
            border-radius: 5px;
            display: none;
        }
        
        .payment-details.active {
            display: block;
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
        
        .modal-btn-secondary {
            background-color: #2196F3;
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
        <div class="booking-container">
            <form action="process-order" method="post" class="booking-form" id="orderForm">
                <h2>Shipping Details</h2>
                <div class="form-group">
                    <label for="name">Full Name</label>
                    <input type="text" id="name" name="name" value="<%= user.getName() %>" required readonly>
                </div>
                
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" value="<%= user.getEmail() %>" required readonly>
                </div>
                
                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="tel" id="phone" name="phone" value="<%= user.getPhone() %>" required readonly>
                </div>
                
                <div class="form-group">
                    <label for="address">Delivery Address</label>
                    <textarea id="address" name="address" required readonly><%= user.getAddress() %></textarea>
                </div>
                
                <div class="payment-methods">
                    <h2>Payment Method</h2>
                    
                    <div class="payment-option">
                        <input type="radio" id="cod" name="paymentMethod" value="cod" required checked>
                        <img src="images/cod.png" alt="Cash on Delivery" class="payment-icon">
                        <span>Cash on Delivery</span>
                    </div>
                    
                    <div class="payment-option">
                        <input type="radio" id="card" name="paymentMethod" value="card">
                        <img src="images/credit-card.png" alt="Credit Card" class="payment-icon">
                        <span>Credit/Debit Card</span>
                    </div>
                    
                    <div class="payment-option">
                        <input type="radio" id="upi" name="paymentMethod" value="upi">
                        <img src="images/upi.png" alt="UPI" class="payment-icon">
                        <span>UPI Payment</span>
                    </div>
                </div>
                
                <button type="button" class="btn" onclick="submitOrder()">Place Order</button>
            </form>
            
            <div class="order-summary">
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
                <% } else { %>
                    <p>Your cart is empty</p>
                <% } %>
            </div>
        </div>
    </div>
    
    <!-- Success Modal -->
    <div id="successModal" class="modal">
        <div class="modal-content">
            <div class="modal-icon">✓</div>
            <h2>Order Placed Successfully!</h2>
            <p>Thank you for your order. Your order has been received and is being processed.</p>
            <div class="modal-buttons">
                <a href="products.jsp" class="modal-btn modal-btn-primary">Continue Shopping</a>
                <a href="orders.jsp" class="modal-btn modal-btn-secondary">View Orders</a>
            </div>
        </div>
    </div>
    
    <script>
        function submitOrder() {
            var paymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
            
            if (paymentMethod === 'cod') {
                // Show success modal for COD
                document.getElementById('successModal').style.display = 'block';
                
                // Submit form after a short delay
                setTimeout(function() {
                    document.getElementById('orderForm').submit();
                }, 2000);
            } else {
                // Redirect to payment page for card/UPI
                window.location.href = 'payment.jsp?method=' + paymentMethod;
            }
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