<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pesticides.model.User, com.pesticides.model.Cart, com.pesticides.model.CartItem" %>
<!DOCTYPE html>
<html>
<head>
    <title>Payment - Agros Pesticides</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <style>
        .payment-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 2rem;
        }
        .payment-methods {
            background-color: #f8f9fa;
            padding: 1.5rem;
            border-radius: 0.5rem;
            margin-bottom: 2rem;
        }
        .qr-container {
            text-align: center;
            padding: 2rem;
            background-color: white;
            border-radius: 0.5rem;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        .qr-code {
            max-width: 300px;
            margin: 0 auto;
        }
        .payment-instructions {
            background-color: #fff;
            padding: 1.5rem;
            border-radius: 0.5rem;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .payment-method {
            cursor: pointer;
            padding: 1rem;
            border: 2px solid #dee2e6;
            border-radius: 0.5rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
        }
        .payment-method:hover {
            border-color: #0d6efd;
            background-color: #f8f9fa;
        }
        .payment-method.selected {
            border-color: #0d6efd;
            background-color: #e7f1ff;
        }
        .payment-method img {
            height: 40px;
            margin-right: 1rem;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="container mt-4">
        <div class="payment-container">
            <%
            Cart cart = (Cart) session.getAttribute("cart");
            User user = (User) session.getAttribute("user");
            
            if (cart == null || cart.getItems().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cart.jsp");
                return;
            }
            %>
            
            <h2 class="text-center mb-4">Payment Details</h2>
            
            <div class="payment-methods">
                <h4 class="mb-4">Select Payment Method</h4>
                
                <div class="payment-method" onclick="selectPaymentMethod('upi')">
                    <div class="d-flex align-items-center">
                        <img src="images/upi-logo.png" alt="UPI">
                        <div>
                            <h5 class="mb-1">UPI Payment</h5>
                            <p class="text-muted mb-0">Pay using any UPI app</p>
                        </div>
                    </div>
                </div>
                
                <div class="payment-method" onclick="selectPaymentMethod('card')">
                    <div class="d-flex align-items-center">
                        <img src="images/card-logo.png" alt="Card">
                        <div>
                            <h5 class="mb-1">Credit/Debit Card</h5>
                            <p class="text-muted mb-0">Pay using your card</p>
                        </div>
                    </div>
                </div>
                
                <div class="payment-method" onclick="selectPaymentMethod('netbanking')">
                    <div class="d-flex align-items-center">
                        <img src="images/netbanking-logo.png" alt="Net Banking">
                        <div>
                            <h5 class="mb-1">Net Banking</h5>
                            <p class="text-muted mb-0">Pay using your bank account</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <div id="upiPayment" class="qr-container">
                <h4 class="mb-4">Scan QR Code to Pay</h4>
                <img src="images/payment-qr.png" alt="Payment QR Code" class="qr-code mb-4">
                <p class="text-muted">Amount to Pay: ₹<%= String.format("%.2f", cart.getTotalAmount()) %></p>
                <p class="text-muted">UPI ID: agros@upi</p>
            </div>
            
            <div id="cardPayment" class="payment-instructions" style="display: none;">
                <h4 class="mb-4">Card Payment</h4>
                <form id="cardForm">
                    <div class="mb-3">
                        <label for="cardNumber" class="form-label">Card Number</label>
                        <input type="text" class="form-control" id="cardNumber" placeholder="1234 5678 9012 3456" required>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="expiryDate" class="form-label">Expiry Date</label>
                            <input type="text" class="form-control" id="expiryDate" placeholder="MM/YY" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="cvv" class="form-label">CVV</label>
                            <input type="text" class="form-control" id="cvv" placeholder="123" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="cardName" class="form-label">Name on Card</label>
                        <input type="text" class="form-control" id="cardName" required>
                    </div>
                </form>
            </div>
            
            <div id="netbankingPayment" class="payment-instructions" style="display: none;">
                <h4 class="mb-4">Net Banking</h4>
                <div class="list-group">
                    <a href="#" class="list-group-item list-group-item-action">
                        <div class="d-flex align-items-center">
                            <img src="images/sbi-logo.png" alt="SBI" height="30" class="me-3">
                            <span>State Bank of India</span>
                        </div>
                    </a>
                    <a href="#" class="list-group-item list-group-item-action">
                        <div class="d-flex align-items-center">
                            <img src="images/hdfc-logo.png" alt="HDFC" height="30" class="me-3">
                            <span>HDFC Bank</span>
                        </div>
                    </a>
                    <a href="#" class="list-group-item list-group-item-action">
                        <div class="d-flex align-items-center">
                            <img src="images/icici-logo.png" alt="ICICI" height="30" class="me-3">
                            <span>ICICI Bank</span>
                        </div>
                    </a>
                </div>
            </div>
            
            <div class="d-grid gap-2 mt-4">
                <button type="button" class="btn btn-primary btn-lg" onclick="processPayment()">
                    <i class="fas fa-lock me-2"></i>Complete Payment
                </button>
                <button type="button" class="btn btn-outline-secondary" onclick="window.location.href='checkout.jsp'">
                    <i class="fas fa-arrow-left me-2"></i>Back to Checkout
                </button>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function selectPaymentMethod(method) {
            // Remove selected class from all payment methods
            document.querySelectorAll('.payment-method').forEach(el => {
                el.classList.remove('selected');
            });
            
            // Add selected class to clicked payment method
            event.currentTarget.classList.add('selected');
            
            // Hide all payment sections
            document.getElementById('upiPayment').style.display = 'none';
            document.getElementById('cardPayment').style.display = 'none';
            document.getElementById('netbankingPayment').style.display = 'none';
            
            // Show selected payment section
            document.getElementById(method + 'Payment').style.display = 'block';
        }
        
        function processPayment() {
            // Here you would typically integrate with a payment gateway
            // For demo purposes, we'll just show a success message
            alert('Payment successful! Your order has been placed.');
            window.location.href = 'order-confirmation.jsp';
        }
    </script>
</body>
</html> 