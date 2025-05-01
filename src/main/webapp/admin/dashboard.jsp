<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.pesticides.model.Product" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Agro's</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }
        .nav {
            background-color: #4CAF50;
            padding: 15px;
            text-align: center;
        }
        .nav a {
            color: white;
            text-decoration: none;
            margin: 0 15px;
            font-size: 18px;
        }
        .nav a:hover {
            text-decoration: underline;
        }
        .container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .dashboard-card {
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .dashboard-card h2 {
            color: #4CAF50;
            margin-top: 0;
        }
        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        .action-btn {
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            color: white;
        }
        .add-btn {
            background-color: #4CAF50;
        }
        .manage-btn {
            background-color: #2196F3;
        }
        .action-btn:hover {
            opacity: 0.9;
        }
        .product-list {
            margin-top: 30px;
        }
        .product-item {
            display: flex;
            align-items: center;
            padding: 15px;
            border-bottom: 1px solid #eee;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .product-item:hover {
            background-color: #f5f5f5;
        }
        .product-item img {
            width: 60px;
            height: 60px;
            object-fit: cover;
            margin-right: 20px;
        }
        .product-details {
            flex-grow: 1;
        }
        .product-name {
            font-weight: bold;
            font-size: 16px;
        }
        .product-price {
            color: #4CAF50;
            font-size: 14px;
        }
        .product-actions {
            display: flex;
            gap: 10px;
        }
        .delete-btn {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            color: white;
            background-color: #f44336;
        }
        .edit-form {
            display: none;
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 5px;
            margin-top: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .edit-form input,
        .edit-form textarea {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .edit-form button {
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 10px;
        }
        .save-btn {
            background-color: #4CAF50;
            color: white;
        }
        .cancel-btn {
            background-color: #f44336;
            color: white;
        }
        .selected {
            background-color: #e8f5e9;
        }
        .error-message {
            color: #f44336;
            margin-bottom: 15px;
            padding: 10px;
            background-color: #ffebee;
            border-radius: 4px;
        }
        .success-message {
            color: #4CAF50;
            margin-bottom: 15px;
            padding: 10px;
            background-color: #e8f5e9;
            border-radius: 4px;
        }
        .product-stock, .product-category {
            font-size: 12px;
            color: #666;
            margin-top: 4px;
        }
    </style>
</head>
<body>
    <div class="nav">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="products.jsp">Products</a>
        <a href="orders.jsp">Orders</a>
        <a href="../logout">Logout</a>
    </div>

    <div class="container">
        <h1>Admin Dashboard</h1>
        
        <%
            String error = (String) request.getAttribute("error");
            String success = (String) request.getAttribute("success");
            if (error != null) {
        %>
            <div class="error-message">
                <%= error %>
            </div>
        <%
            }
            if (success != null) {
        %>
            <div class="success-message">
                <%= success %>
            </div>
        <%
            }
        %>

        <div class="dashboard-grid">
            <div class="dashboard-card">
                <h2>Product Management</h2>
                <p>Add, edit, or remove products from the store</p>
                <div class="action-buttons">
                    <a href="products" class="action-btn manage-btn">Manage Products</a>
                </div>
            </div>
            
            <div class="dashboard-card">
                <h2>Quick Actions</h2>
                <p>Common administrative tasks</p>
                <div class="action-buttons">
                    <a href="products?action=add" class="action-btn add-btn">Add New Product</a>
                </div>
            </div>
        </div>

        <div class="product-list">
            <h2>Recent Products</h2>
            <%
                List<Product> products = (List<Product>) request.getAttribute("products");
                if (products == null || products.isEmpty()) {
                    products = (List<Product>) session.getAttribute("products");
                }
                
                if (products != null && !products.isEmpty()) {
                    for (Product product : products) {
            %>
                <div class="product-item" onclick="toggleEditForm(<%= product.getId() %>)">
                    <img src="<%= product.getImageUrl() != null ? product.getImageUrl() : "../images/no-image.png" %>" 
                         alt="<%= product.getName() %>">
                    <div class="product-details">
                        <div class="product-name"><%= product.getName() %></div>
                        <div class="product-price">₹<%= String.format("%.2f", product.getPrice()) %></div>
                        <div class="product-category">Category: <%= product.getCategory() %></div>
                        <div class="product-stock">Stock: <%= product.getStock() %></div>
                    </div>
                    <div class="product-actions">
                        <a href="products?action=edit&id=<%= product.getId() %>" 
                           class="action-btn manage-btn">Edit</a>
                        <button class="delete-btn" onclick="deleteProduct(event, <%= product.getId() %>)">Delete</button>
                    </div>
                    <div id="editForm_<%= product.getId() %>" class="edit-form">
                        <form onsubmit="return updateProduct(event, <%= product.getId() %>)">
                            <input type="hidden" name="id" value="<%= product.getId() %>">
                            <input type="text" name="name" value="<%= product.getName() %>" placeholder="Product Name" required>
                            <input type="number" name="price" value="<%= product.getPrice() %>" step="0.01" placeholder="Price" required>
                            <input type="text" name="category" value="<%= product.getCategory() %>" placeholder="Category" required>
                            <input type="number" name="stock" value="<%= product.getStock() %>" placeholder="Stock" required>
                            <textarea name="description" placeholder="Description" required><%= product.getDescription() %></textarea>
                            <input type="file" name="image" accept="image/*">
                            <button type="submit" class="save-btn">Update</button>
                            <button type="button" class="cancel-btn" onclick="toggleEditForm(<%= product.getId() %>)">Cancel</button>
                        </form>
                    </div>
                </div>
            <%
                    }
                } else {
            %>
                <div class="alert alert-info">No products available.</div>
            <%
                }
            %>
        </div>
    </div>

    <script>
        function toggleEditForm(productId) {
            // Hide all other edit forms
            document.querySelectorAll('.edit-form').forEach(form => {
                form.style.display = 'none';
            });
            
            // Remove selected class from all items
            document.querySelectorAll('.product-item').forEach(item => {
                item.classList.remove('selected');
            });
            
            const editForm = document.getElementById(`editForm_${productId}`);
            const productItem = editForm.closest('.product-item');
            
            if (editForm.style.display === 'block') {
                editForm.style.display = 'none';
                productItem.classList.remove('selected');
            } else {
                editForm.style.display = 'block';
                productItem.classList.add('selected');
            }
        }

        function updateProduct(event, productId) {
            event.preventDefault();
            event.stopPropagation(); // Prevent the click from bubbling up to the product item
            
            const form = event.target;
            const formData = new FormData(form);
            formData.append('action', 'edit');
            
            fetch('products', {
                method: 'POST',
                body: formData,
                headers: {
                    'Accept': 'application/json'
                }
            })
            .then(response => {
                if (response.ok) {
                    return response.json();
                }
                throw new Error('Network response was not ok');
            })
            .then(data => {
                if (data.success) {
                    window.location.reload();
                } else {
                    alert(data.error || 'Error updating product');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error updating product: ' + error.message);
            });
            
            return false;
        }

        function deleteProduct(event, productId) {
            event.stopPropagation(); // Prevent the click from bubbling up to the product item
            
            if (confirm('Are you sure you want to delete this product?')) {
                window.location.href = 'products?action=delete&id=' + productId;
            }
        }
    </script>
</body>
</html> 