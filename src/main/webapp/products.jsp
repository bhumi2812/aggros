<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.fertilizer.model.Product" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Products - Fertilizer Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <style>
        .product-card {
            transition: transform 0.2s;
            margin-bottom: 20px;
            height: 100%;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .category-filter {
            margin-bottom: 20px;
        }
        .product-image {
            height: 200px;
            object-fit: cover;
        }
        .quantity-input {
            width: 70px;
        }
        .rating {
            color: #ffc107;
        }
        .category-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: rgba(0,0,0,0.7);
            color: white;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.8rem;
        }
        .stock-info {
            font-size: 0.9rem;
        }
        .stock-low {
            color: #dc3545;
        }
        .stock-available {
            color: #28a745;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="container mt-4">
        <h2 class="mb-4">Our Products</h2>
        
        <!-- Category Filter -->
        <div class="category-filter">
            <div class="btn-group" role="group">
                <a href="products" class="btn btn-outline-primary ${empty selectedCategory ? 'active' : ''}">All</a>
                <%
                    List<String> categories = (List<String>) request.getAttribute("categories");
                    String selectedCategory = (String) request.getAttribute("selectedCategory");
                    if (categories != null) {
                        for (String category : categories) {
                %>
                    <a href="products?category=<%= category %>" 
                       class="btn btn-outline-primary <%= category.equals(selectedCategory) ? "active" : "" %>">
                        <%= category %>
                    </a>
                <%
                        }
                    }
                %>
            </div>
        </div>
        
        <!-- Messages -->
        <%
            String successMessage = (String) session.getAttribute("successMessage");
            String errorMessage = (String) session.getAttribute("errorMessage");
            if (successMessage != null) {
        %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <%= successMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <%
                session.removeAttribute("successMessage");
            }
            if (errorMessage != null) {
        %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <%= errorMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <%
                session.removeAttribute("errorMessage");
            }
        %>
        
        <!-- Products Grid -->
        <div class="row row-cols-1 row-cols-md-3 g-4">
            <%
                List<Product> products = (List<Product>) request.getAttribute("products");
                if (products != null && !products.isEmpty()) {
                    for (Product product : products) {
                        String stockClass = product.getStock() <= 5 ? "stock-low" : "stock-available";
            %>
                <div class="col">
                    <div class="card h-100 product-card">
                        <div class="position-relative">
                            <img src="<%= product.getImageUrl() %>" class="card-img-top product-image" alt="<%= product.getName() %>">
                            <span class="category-badge"><%= product.getCategory() %></span>
                        </div>
                        <div class="card-body">
                            <h5 class="card-title"><%= product.getName() %></h5>
                            <p class="card-text"><%= product.getDescription() %></p>
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <div class="rating">
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star-half-alt"></i>
                                </div>
                                <h5 class="text-success mb-0">₹<%= product.getPrice() %></h5>
                            </div>
                            <p class="card-text <%= stockClass %>">
                                <i class="fas fa-box"></i> Stock: <%= product.getStock() %>
                            </p>
                            
                            <form action="products" method="post" class="mt-3">
                                <input type="hidden" name="action" value="addToCart">
                                <input type="hidden" name="productId" value="<%= product.getId() %>">
                                <div class="input-group">
                                    <input type="number" name="quantity" class="form-control quantity-input" 
                                           value="1" min="1" max="<%= product.getStock() %>">
                                    <button type="submit" class="btn btn-success" 
                                            <%= product.getStock() <= 0 ? "disabled" : "" %>>
                                        <i class="fas fa-shopping-cart"></i> Add to Cart
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            <%
                    }
                } else {
            %>
                <div class="col-12">
                    <div class="alert alert-info">No products found in this category.</div>
                </div>
            <%
                }
            %>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 