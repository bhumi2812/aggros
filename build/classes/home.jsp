<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.pesticides.model.Product" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Home - Fertilizer Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <style>
        .carousel-item {
            height: 500px;
        }
        .carousel-item img {
            object-fit: cover;
            height: 100%;
        }
        .product-card {
            transition: transform 0.2s;
            margin-bottom: 20px;
            height: 100%;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .product-image {
            height: 200px;
            object-fit: cover;
        }
        .featured-section {
            padding: 50px 0;
            background-color: #f8f9fa;
        }
        .section-title {
            margin-bottom: 30px;
            text-align: center;
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
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <!-- Hero Carousel -->
    <div id="heroCarousel" class="carousel slide" data-bs-ride="carousel">
        <div class="carousel-indicators">
            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="0" class="active"></button>
            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="1"></button>
            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="2"></button>
        </div>
        <div class="carousel-inner">
            <div class="carousel-item active">
                <img src="https://source.unsplash.com/random/1200x500/?fertilizer" class="d-block w-100" alt="Fertilizer 1">
                <div class="carousel-caption">
                    <h2>Premium Quality Fertilizers</h2>
                    <p>Boost your crop yield with our organic fertilizers</p>
                    <a href="products" class="btn btn-success btn-lg">Shop Now</a>
                </div>
            </div>
            <div class="carousel-item">
                <img src="https://source.unsplash.com/random/1200x500/?agriculture" class="d-block w-100" alt="Fertilizer 2">
                <div class="carousel-caption">
                    <h2>Expert Agricultural Solutions</h2>
                    <p>Get the best advice for your farming needs</p>
                    <a href="products" class="btn btn-success btn-lg">Explore Products</a>
                </div>
            </div>
            <div class="carousel-item">
                <img src="https://source.unsplash.com/random/1200x500/?farm" class="d-block w-100" alt="Fertilizer 3">
                <div class="carousel-caption">
                    <h2>Organic & Sustainable</h2>
                    <p>Environmentally friendly products for better farming</p>
                    <a href="products" class="btn btn-success btn-lg">Learn More</a>
                </div>
            </div>
        </div>
        <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
            <span class="carousel-control-prev-icon"></span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
            <span class="carousel-control-next-icon"></span>
        </button>
    </div>

    <!-- Featured Products Section -->
    <div class="featured-section">
        <div class="container">
            <h2 class="section-title">Featured Products</h2>
            <div class="row row-cols-1 row-cols-md-3 g-4">
                <%
                    List<Product> featuredProducts = (List<Product>) request.getAttribute("featuredProducts");
                    if (featuredProducts != null && !featuredProducts.isEmpty()) {
                        for (Product product : featuredProducts) {
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
                                <div class="d-flex justify-content-between align-items-center">
                                    <h5 class="text-success mb-0">₹<%= product.getPrice() %></h5>
                                    <a href="products?category=<%= product.getCategory() %>" class="btn btn-outline-success">View Category</a>
                                </div>
                            </div>
                        </div>
                    </div>
                <%
                        }
                    } else {
                %>
                    <div class="col-12">
                        <div class="alert alert-info">No featured products available.</div>
                    </div>
                <%
                    }
                %>
            </div>
        </div>
    </div>

    <!-- Why Choose Us Section -->
    <div class="container py-5">
        <h2 class="section-title">Why Choose Us</h2>
        <div class="row text-center">
            <div class="col-md-4">
                <div class="p-4">
                    <i class="fas fa-leaf fa-3x text-success mb-3"></i>
                    <h4>Organic Products</h4>
                    <p>100% natural and organic fertilizers for sustainable farming</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="p-4">
                    <i class="fas fa-truck fa-3x text-success mb-3"></i>
                    <h4>Fast Delivery</h4>
                    <p>Quick and reliable delivery to your doorstep</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="p-4">
                    <i class="fas fa-headset fa-3x text-success mb-3"></i>
                    <h4>24/7 Support</h4>
                    <p>Expert support for all your agricultural needs</p>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 