<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.fertilizer.model.Order" %>
<%@ page import="com.fertilizer.model.OrderItem" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<jsp:include page="header.jsp" />

<div class="container mt-4">
    <h2>Your Orders</h2>
    
    <%
        String successMessage = (String) session.getAttribute("successMessage");
        String errorMessage = (String) session.getAttribute("errorMessage");
        
        if (successMessage != null) {
    %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <%= successMessage %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <%
            session.removeAttribute("successMessage");
        }
        
        if (errorMessage != null) {
    %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <%= errorMessage %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <%
            session.removeAttribute("errorMessage");
        }
    %>
    
    <%
        List<Order> orders = (List<Order>) request.getAttribute("orders");
        SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy HH:mm");
        
        if (orders == null || orders.isEmpty()) {
    %>
        <div class="alert alert-info">
            You haven't placed any orders yet. <a href="products">Start shopping</a>
        </div>
    <%
        } else {
            for (Order order : orders) {
    %>
        <div class="card mb-4">
            <div class="card-header">
                <div class="row">
                    <div class="col-md-6">
                        <h5 class="mb-0">Order #<%= order.getId() %></h5>
                    </div>
                    <div class="col-md-6 text-end">
                        <span class="badge bg-<%= order.getStatus().equals("PENDING") ? "warning" : 
                            (order.getStatus().equals("COMPLETED") ? "success" : "danger") %>">
                            <%= order.getStatus() %>
                        </span>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-8">
                        <%
                            for (OrderItem item : order.getItems()) {
                        %>
                            <div class="row mb-3">
                                <div class="col-md-2">
                                    <img src="<%= item.getProduct().getImageUrl() %>" 
                                         class="img-fluid rounded" 
                                         alt="<%= item.getProduct().getName() %>">
                                </div>
                                <div class="col-md-6">
                                    <h6><%= item.getProduct().getName() %></h6>
                                    <p class="text-muted mb-0"><%= item.getProduct().getDescription() %></p>
                                    <p class="mb-0">Quantity: <%= item.getQuantity() %></p>
                                </div>
                                <div class="col-md-4 text-end">
                                    <p class="mb-0">$<%= String.format("%.2f", item.getPrice()) %></p>
                                    <p class="mb-0">Total: $<%= String.format("%.2f", item.getTotal()) %></p>
                                </div>
                            </div>
                        <%
                            }
                        %>
                    </div>
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-body">
                                <h6>Order Summary</h6>
                                <p class="mb-0">Order Date: <%= dateFormat.format(order.getCreatedAt()) %></p>
                                <p class="mb-0">Total Items: <%= order.getItems().size() %></p>
                                <p class="mb-0">Total Amount: $<%= String.format("%.2f", order.getTotalAmount()) %></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    <%
            }
        }
    %>
</div>

 