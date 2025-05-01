package com.pesticides.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

import com.pesticides.dao.ProductDAO;
import com.pesticides.model.Product;

@WebServlet("/admin/admin-login")
public class AdminLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Hardcoded admin credentials (in production, use a database)
    private static final String ADMIN_EMAIL = "admin@agros.com";
    private static final String ADMIN_PASSWORD = "admin123";
    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        System.out.println("\n=== ADMIN LOGIN ATTEMPT ===");
        System.out.println("Email: " + email);
        
        if (email == null || password == null || 
            !email.equals(ADMIN_EMAIL) || !password.equals(ADMIN_PASSWORD)) {
            System.out.println("Login failed: Invalid credentials");
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
            return;
        }

        System.out.println("Login successful!");
        
        List<Product> productList = productDAO.getAllProducts();
        
        // Print product details to console
        System.out.println("\n=== PRODUCT LIST ===");
        System.out.println("ID\tName\t\tCategory\tPrice\tStock");
        System.out.println("--------------------------------------------------");
        
        for (Product product : productList) {
            System.out.printf("%d\t%-15s\t%-10s\t₹%.2f\t%d%n",
                product.getId(),
                product.getName(),
                product.getCategory(),
                product.getPrice(),
                product.getStock()
            );
        }
        System.out.println("--------------------------------------------------");
        System.out.println("Total Products: " + productList.size());
        
        // Create session and set admin attribute
        HttpSession session = request.getSession();
        session.setAttribute("admin", true);
        session.setAttribute("products", productList);
        
        // Set products in request attribute as well
        request.setAttribute("products", productList);
        
        // Forward to dashboard.jsp instead of redirect
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
} 