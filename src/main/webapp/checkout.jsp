<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pesticides.model.User, com.pesticides.model.Cart, com.pesticides.model.CartItem" %>
<!DOCTYPE html>
<html>
<head>
    <title>Checkout - Agros Pesticides</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <style>
        .checkout-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }
        .user-details {
            background-color: #f8f9fa;
            padding: 1.5rem;
            border-radius: 0.5rem;
            margin-bottom: 2rem;
        }
        .order-summary {
            background-color: #fff;
            padding: 1.5rem;
            border-radius: 0.5rem;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .cart-item {
            border-bottom: 1px solid #eee;
            padding: 1rem 0;
        }
        .cart-item:last-child {
            border-bottom: none;
        }
        .product-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 0.25rem;
        }
        .address-form {
            display: none;
        }
        .address-form.show {
            display: block;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="container mt-4">
        <div class="checkout-container">
            <%
            // Get session and check if cart exists
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null || cart.getItems().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cart.jsp");
                return;
            }
            
            // Get user from session
            User user = null;
            if (session.getAttribute("user") != null) {
                user = (User) session.getAttribute("user");
            }
            %>
            
            <div class="row">
                <div class="col-md-8">
                    <div class="user-details">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4>Shipping Details</h4>
                            <button type="button" class="btn btn-outline-primary" onclick="toggleAddressForm()">
                                <i class="fas fa-edit me-2"></i>Edit Details
                            </button>
                        </div>

                        <!-- Display User Details -->
                        <div id="userDetailsDisplay">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <p><strong>Name:</strong> <span id="displayName"><%= user != null ? user.getUsername() : "Guest User" %></span></p>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <p><strong>Email:</strong> <span id="displayEmail"><%= user != null ? user.getEmail() : "Not provided" %></span></p>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <p><strong>Phone:</strong> <span id="displayPhone"><%= user != null && user.getPhone() != null && !user.getPhone().isEmpty() ? user.getPhone() : "Not provided" %></span></p>
                                </div>
                                <div class="col-md-12 mb-3">
                                    <p><strong>Address:</strong> <span id="displayAddress"><%= user != null && user.getAddress() != null && !user.getAddress().isEmpty() ? user.getAddress() : "Not provided" %></span></p>
                                </div>
                            </div>
                        </div>

                        <!-- Edit Address Form -->
                        <form id="addressForm" class="address-form" action="${pageContext.request.contextPath}/update-address" method="post">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="name" class="form-label">Name</label>
                                    <input type="text" class="form-control" id="name" name="name" 
                                           value="<%= user != null ? user.getUsername() : "" %>" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" name="email" 
                                           value="<%= user != null ? user.getEmail() : "" %>" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="phone" class="form-label">Phone Number</label>
                                    <input type="tel" class="form-control" id="phone" name="phone" 
                                           value="<%= user != null && user.getPhone() != null ? user.getPhone() : "" %>">
                                </div>
                                <div class="col-md-12 mb-3">
                                    <label for="address" class="form-label">Address</label>
                                    <textarea class="form-control" id="address" name="address" rows="3"><%= user != null && user.getAddress() != null ? user.getAddress() : "" %></textarea>
                                </div>
                            </div>
                            <div class="d-flex justify-content-end gap-2">
                                <button type="button" class="btn btn-secondary" onclick="toggleAddressForm()">Cancel</button>
                                <button type="submit" class="btn btn-primary">Save Changes</button>
                            </div>
                        </form>
                    </div>
                    
                    <form action="payment.jsp" method="post">
                        <input type="hidden" name="name" id="hiddenName" value="<%= user != null ? user.getUsername() : "Guest User" %>">
                        <input type="hidden" name="email" id="hiddenEmail" value="<%= user != null ? user.getEmail() : "" %>">
                        <input type="hidden" name="phone" id="hiddenPhone" value="<%= user != null && user.getPhone() != null ? user.getPhone() : "" %>">
                        <input type="hidden" name="address" id="hiddenAddress" value="<%= user != null && user.getAddress() != null ? user.getAddress() : "" %>">
                        
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-check-circle me-2"></i>Proceed to Payment
                            </button>
                        </div>
                    </form>
                </div>
                
                <div class="col-md-4">
                    <div class="order-summary">
                        <h4 class="mb-4">Order Summary</h4>
                        <div class="list-group mb-3">
                            <% for (Cart.CartItem item : cart.getItems()) { %>
                                <div class="cart-item">
                                    <div class="row align-items-center">
                                        <div class="col-3">
                                            <img src="<%= item.getProduct().getImageUrl() != null ? item.getProduct().getImageUrl() : "images/default-product.jpg" %>" 
                                                 alt="<%= item.getProduct().getName() %>" 
                                                 class="product-image">
                                        </div>
                                        <div class="col-6">
                                            <h6 class="mb-1"><%= item.getProduct().getName() %></h6>
                                            <p class="text-muted mb-0">Qty: <%= item.getQuantity() %></p>
                                        </div>
                                        <div class="col-3 text-end">
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
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function toggleAddressForm() {
            const displayDiv = document.getElementById('userDetailsDisplay');
            const formDiv = document.getElementById('addressForm');
            
            if (formDiv.classList.contains('show')) {
                formDiv.classList.remove('show');
                displayDiv.style.display = 'block';
            } else {
                formDiv.classList.add('show');
                displayDiv.style.display = 'none';
            }
        }

        // Update hidden form fields when address form is submitted
        document.getElementById('addressForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Update display values
            document.getElementById('displayName').textContent = document.getElementById('name').value;
            document.getElementById('displayEmail').textContent = document.getElementById('email').value;
            document.getElementById('displayPhone').textContent = document.getElementById('phone').value || 'Not provided';
            document.getElementById('displayAddress').textContent = document.getElementById('address').value || 'Not provided';
            
            // Update hidden form fields
            document.getElementById('hiddenName').value = document.getElementById('name').value;
            document.getElementById('hiddenEmail').value = document.getElementById('email').value;
            document.getElementById('hiddenPhone').value = document.getElementById('phone').value;
            document.getElementById('hiddenAddress').value = document.getElementById('address').value;
            
            // Submit the form
            this.submit();
        });
    </script>
</body>
</html> 