<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pesticides.model.Product" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Product - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .container {
            max-width: 800px;
            margin-top: 30px;
        }
        .form-container {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 20px;
        }
        .error-message {
            color: #dc3545;
            margin-top: 5px;
        }
        .success-message {
            color: #198754;
            margin-top: 5px;
        }
        .preview-image {
            max-width: 200px;
            max-height: 200px;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <jsp:include page="../header.jsp" />
    
    <div class="container">
        <div class="form-container">
            <h2 class="mb-4">Edit Product</h2>
            
            <%
                Product product = (Product) request.getAttribute("product");
                String error = (String) request.getAttribute("error");
                String success = (String) request.getAttribute("success");
                
                if (error != null) {
            %>
                <div class="alert alert-danger" role="alert">
                    <%= error %>
                </div>
            <%
                }
                if (success != null) {
            %>
                <div class="alert alert-success" role="alert">
                    <%= success %>
                </div>
            <%
                }
            %>
            
            <form action="products" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="id" value="<%= product.getId() %>">
                
                <div class="form-group">
                    <label for="name" class="form-label">Product Name</label>
                    <input type="text" class="form-control" id="name" name="name" 
                           value="<%= product.getName() %>" required>
                </div>
                
                <div class="form-group">
                    <label for="description" class="form-label">Description</label>
                    <textarea class="form-control" id="description" name="description" 
                              rows="3" required><%= product.getDescription() %></textarea>
                </div>
                
                <div class="form-group">
                    <label for="price" class="form-label">Price (₹)</label>
                    <input type="number" class="form-control" id="price" name="price" 
                           value="<%= product.getPrice() %>" step="0.01" min="0" required>
                </div>
                
                <div class="form-group">
                    <label for="category" class="form-label">Category</label>
                    <select class="form-select" id="category" name="category" required>
                        <option value="Fertilizers" <%= product.getCategory().equals("Fertilizers") ? "selected" : "" %>>Fertilizers</option>
                        <option value="Pesticides" <%= product.getCategory().equals("Pesticides") ? "selected" : "" %>>Pesticides</option>
                        <option value="Seeds" <%= product.getCategory().equals("Seeds") ? "selected" : "" %>>Seeds</option>
                        <option value="Tools" <%= product.getCategory().equals("Tools") ? "selected" : "" %>>Tools</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="stock" class="form-label">Stock</label>
                    <input type="number" class="form-control" id="stock" name="stock" 
                           value="<%= product.getStock() %>" min="0" required>
                </div>
                
                <div class="form-group">
                    <label for="image" class="form-label">Product Image</label>
                    <input type="file" class="form-control" id="image" name="image" accept="image/*">
                    <% if (product.getImageUrl() != null && !product.getImageUrl().isEmpty()) { %>
                        <div class="mt-2">
                            <p>Current Image:</p>
                            <img src="<%= product.getImageUrl() %>" alt="Current Product Image" class="preview-image">
                        </div>
                    <% } %>
                </div>
                
                <div class="form-group">
                    <label for="rating" class="form-label">Rating</label>
                    <input type="number" class="form-control" id="rating" name="rating" 
                           value="<%= product.getRating() %>" step="0.1" min="0" max="5">
                </div>
                
                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                    <a href="products" class="btn btn-secondary me-md-2">Cancel</a>
                    <button type="submit" class="btn btn-primary">Update Product</button>
                </div>
            </form>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Preview image when selected
        document.getElementById('image').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const preview = document.createElement('img');
                    preview.src = e.target.result;
                    preview.className = 'preview-image';
                    
                    const previewContainer = document.querySelector('.preview-image').parentElement;
                    previewContainer.innerHTML = '';
                    previewContainer.appendChild(preview);
                }
                reader.readAsDataURL(file);
            }
        });
    </script>
</body>
</html> 