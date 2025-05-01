<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pesticides.model.User" %>
<%
    User user = (User) session.getAttribute("user");
%>
<nav class="navbar navbar-expand-lg navbar-dark bg-success">
    <div class="container">
        <a class="navbar-brand" href="home.jsp">Pesticides Shop</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="products">Products</a>
                </li>
                <% if (user != null) { %>
                    <li class="nav-item">
                        <a class="nav-link" href="cart">Cart</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="orders">Orders</a>
                    </li>
                <% } %>
            </ul>
            <ul class="navbar-nav">
                <% if (user != null) { %>
                    <li class="nav-item">
                        <span class="nav-link">Welcome, <%= user.getUsername() %></span>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="logout">Logout</a>
                    </li>
                <% } else { %>
                    <li class="nav-item">
                        <a class="nav-link" href="login.jsp">Login</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="register.jsp">Register</a>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav> 