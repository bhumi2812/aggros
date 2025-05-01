<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="com.pesticides.model.Product" %>
<!DOCTYPE html>
<html>
<head>
    <title>Products - Agros Pesticides</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <style>
        .product-card {
            margin-bottom: 1.5rem;
            transition: all 0.3s ease;
            height: 100%;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        }
        .product-image {
            height: 200px;
            object-fit: cover;
        }
        .category-section {
            margin-bottom: 3rem;
            padding: 2rem;
            background-color: #f8f9fa;
            border-radius: 0.5rem;
        }
        .category-title {
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #dee2e6;
            color: #0d6efd;
        }
        .price {
            font-size: 1.25rem;
            font-weight: bold;
            color: #198754;
        }
        .rating {
            color: #ffc107;
        }
        .stock-info {
            font-size: 0.875rem;
        }
        .in-stock {
            color: #198754;
        }
        .out-of-stock {
            color: #dc3545;
        }
        .category-icon {
            font-size: 1.5rem;
            margin-right: 0.5rem;
        }
        .product-description {
            height: 3em;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="container mt-4">
        <h1 class="text-center mb-4">Our Products</h1>
        
        <% 
        String error = (String)request.getAttribute("error");
        if (error != null) { 
        %>
            <div class="alert alert-danger"><%= error %></div>
        <% } %>
        
        <%
        @SuppressWarnings("unchecked")
        Map<String, List<Product>> productsByCategory = (Map<String, List<Product>>)session.getAttribute("productsByCategory");
        
        if (productsByCategory != null && !productsByCategory.isEmpty()) {
            for (Map.Entry<String, List<Product>> entry : productsByCategory.entrySet()) {
                String category = entry.getKey();
                List<Product> products = entry.getValue();
                
                if (!products.isEmpty()) {
        %>
            <div class="category-section">
                <h2 class="category-title">
                    <%
                    switch(category) {
                        case "Fertilizers":
                    %>
                        <i class="fas fa-leaf category-icon"></i>
                    <%
                        break;
                        case "Pesticides":
                    %>
                        <i class="fas fa-bug category-icon"></i>
                    <%
                        break;
                        case "Seeds":
                    %>
                        <i class="fas fa-seedling category-icon"></i>
                    <%
                        break;
                        case "Liquids":
                    %>
                        <i class="fas fa-tint category-icon"></i>
                    <%
                        break;
                        case "Organic Products":
                    %>
                        <i class="fas fa-recycle category-icon"></i>
                    <%
                        break;
                        default:
                    %>
                        <i class="fas fa-box category-icon"></i>
                    <%
                    }
                    %>
                    <%= category %>
                </h2>
                <div class="row">
                    <% for (Product product : products) { %>
                        <div class="col-md-4 col-lg-3">
                            <div class="card product-card">
                                <img src="<%= product.getImageUrl() != null ? product.getImageUrl() : "images/default-product.jpg" %>" 
                                     class="card-img-top product-image" 
                                     alt="<%= product.getName() %>">
                                <div class="card-body">
                                    <h5 class="card-title"><%= product.getName() %></h5>
                                    <p class="card-text product-description"><%= product.getDescription() %></p>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="price">$<%= String.format("%.2f", product.getPrice()) %></span>
                                        <div class="rating">
                                            <% for (int i = 0; i < 5; i++) { %>
                                                <i class="fas fa-star<%= i < product.getRating() ? "" : "-o" %>"></i>
                                            <% } %>
                                        </div>
                                    </div>
                                    <div class="stock-info mt-2">
                                        <% if (product.getStock() > 0) { %>
                                            <span class="in-stock">In Stock (<%= product.getStock() %> available)</span>
                                        <% } else { %>
                                            <span class="out-of-stock">Out of Stock</span>
                                        <% } %>
                                    </div>
                                    <form action="cart" method="post" class="mt-3">
                                        <input type="hidden" name="action" value="add">
                                        <input type="hidden" name="productId" value="<%= product.getId() %>">
                                        <div class="input-group">
                                            <input type="number" name="quantity" class="form-control" 
                                                   value="1" min="1" max="<%= product.getStock() %>">
                                            <button type="submit" class="btn btn-primary" 
                                                    <%= product.getStock() <= 0 ? "disabled" : "" %>>
                                                <i class="fas fa-shopping-cart"></i> Add to Cart
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        <% 
                }
            }
        } else {
        %>
            <div class="alert alert-info">No products available at the moment.</div>
        <%
        }
        %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 