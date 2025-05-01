<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${product != null ? 'Edit' : 'Add'} Product</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .container { max-width: 800px; margin-top: 50px; }
        .form-group { margin-bottom: 20px; }
        .error { color: red; }
        .success { color: green; }
        .preview-image {
            max-width: 200px;
            max-height: 200px;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>${product != null ? 'Edit' : 'Add'} Product</h2>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
            <c:remove var="error" scope="session"/>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/admin/products" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
            <input type="hidden" name="action" value="${product != null ? 'edit' : 'add'}">
            <c:if test="${product != null}">
                <input type="hidden" name="id" value="${product.id}">
            </c:if>
            
            <div class="form-group">
                <label for="name">Product Name:</label>
                <input type="text" class="form-control" id="name" name="name" 
                       value="${product != null ? product.name : ''}" required>
            </div>
            
            <div class="form-group">
                <label for="description">Description:</label>
                <textarea class="form-control" id="description" name="description" rows="4" required>${product != null ? product.description : ''}</textarea>
            </div>
            
            <div class="form-group">
                <label for="price">Price:</label>
                <input type="number" class="form-control" id="price" name="price" 
                       value="${product != null ? product.price : ''}" step="0.01" min="0.01" required>
            </div>
            
            <div class="form-group">
                <label for="image">Product Image:</label>
                <input type="file" class="form-control" id="image" name="image" 
                       accept="image/*" ${product == null ? 'required' : ''}>
                <c:if test="${product != null && not empty product.imageUrl}">
                    <div class="mt-2">
                        <p>Current Image:</p>
                        <img src="${pageContext.request.contextPath}/${product.imageUrl}" 
                             alt="Current Product Image" class="preview-image">
                    </div>
                </c:if>
            </div>
            
            <div class="form-group">
                <button type="submit" class="btn btn-primary">${product != null ? 'Update' : 'Add'} Product</button>
                <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>

    <script>
        function validateForm() {
            const name = document.getElementById('name').value.trim();
            const description = document.getElementById('description').value.trim();
            const price = document.getElementById('price').value;
            const image = document.getElementById('image').files[0];
            
            if (!name) {
                alert('Please enter a product name');
                return false;
            }
            
            if (!description) {
                alert('Please enter a product description');
                return false;
            }
            
            if (!price || parseFloat(price) <= 0) {
                alert('Please enter a valid price');
                return false;
            }
            
            if (${product == null} && !image) {
                alert('Please select a product image');
                return false;
            }
            
            if (image) {
                const validTypes = ['image/jpeg', 'image/png', 'image/gif'];
                if (!validTypes.includes(image.type)) {
                    alert('Please select a valid image file (JPEG, PNG, or GIF)');
                    return false;
                }
                
                const maxSize = 10 * 1024 * 1024; // 10MB
                if (image.size > maxSize) {
                    alert('Image size should not exceed 10MB');
                    return false;
                }
            }
            
            return true;
        }
    </script>
</body>
</html> 