<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pesticides.model.Product" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Products - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .container {
            max-width: 1200px;
            margin-top: 30px;
        }
        .card {
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .table th {
            background-color: #f8f9fa;
        }
        .product-image {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 5px;
        }
        .action-buttons .btn {
            margin-right: 5px;
        }
        .alert {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <jsp:include page="../header.jsp" />
    
    <div class="container">
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h3 class="mb-0">Manage Products</h3>
                <a href="add-product.jsp" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Add New Product
                </a>
            </div>
            
            <div class="card-body">
                <%
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
                
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Image</th>
                                <th>Name</th>
                                <th>Category</th>
                                <th>Price</th>
                                <th>Stock</th>
                                <th>Rating</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Product> products = (List<Product>) request.getAttribute("products");
                                if (products != null && !products.isEmpty()) {
                                    for (Product product : products) {
                            %>
                                <tr>
                                    <td>
                                        <img src="<%= product.getImageUrl() %>" alt="<%= product.getName() %>" 
                                             class="product-image">
                                    </td>
                                    <td><%= product.getName() %></td>
                                    <td><%= product.getCategory() %></td>
                                    <td>₹<%= String.format("%.2f", product.getPrice()) %></td>
                                    <td><%= product.getStock() %></td>
                                    <td>
                                        <%
                                            for (int i = 1; i <= 5; i++) {
                                                if (i <= product.getRating()) {
                                        %>
                                            <i class="fas fa-star text-warning"></i>
                                        <%
                                                } else {
                                        %>
                                            <i class="far fa-star text-warning"></i>
                                        <%
                                                }
                                            }
                                        %>
                                    </td>
                                    <td class="action-buttons">
                                        <a href="products?action=edit&id=<%= product.getId() %>" 
                                           class="btn btn-sm btn-primary">
                                            <i class="fas fa-edit"></i> Edit
                                        </a>
                                        <a href="products?action=delete&id=<%= product.getId() %>" 
                                           class="btn btn-sm btn-danger"
                                           onclick="return confirm('Are you sure you want to delete this product?')">
                                            <i class="fas fa-trash"></i> Delete
                                        </a>
                                    </td>
                                </tr>
                            <%
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="7" class="text-center">No products found</td>
                                </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 