package com.pesticides.servlet;

import com.pesticides.dao.OrderDAO;
import com.pesticides.dao.ProductDAO;
import com.pesticides.dao.UserDAO;
import com.pesticides.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/admin/dashboard")
public class AdminServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminServlet.class.getName());
    private UserDAO userDAO;
    private ProductDAO productDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        productDAO = new ProductDAO();
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get total number of users
            int totalUsers = userDAO.getTotalUsers();
            request.setAttribute("totalUsers", totalUsers);

            // Get total number of products
            List<Product> totalProducts = productDAO.getAllProducts();
            request.setAttribute("totalProducts", totalProducts);

            // Print product details to console
            System.out.println("\n=== ADMIN DASHBOARD PRODUCT LIST ===");
            System.out.println("ID\tName\t\tCategory\tPrice\tStock");
            System.out.println("--------------------------------------------------");
            
            for (Product product : totalProducts) {
                System.out.printf("%d\t%-15s\t%-10s\t₹%.2f\t%d%n",
                    product.getId(),
                    product.getName(),
                    product.getCategory(),
                    product.getPrice(),
                    product.getStock()
                );
            }
            System.out.println("--------------------------------------------------");
            System.out.println("Total Products: " + totalProducts.size());
            System.out.println("Total Users: " + totalUsers);

            // Get total number of orders
            int totalOrders = orderDAO.getTotalOrders();
            request.setAttribute("totalOrders", totalOrders);

            // Get total revenue
            double totalRevenue = orderDAO.getTotalRevenue();
            request.setAttribute("totalRevenue", totalRevenue);

            // Get recent orders
            request.setAttribute("recentOrders", orderDAO.getRecentOrders(5));

            // Get order statistics by status
            request.setAttribute("pendingOrders", orderDAO.getOrdersByStatus("Pending"));
            request.setAttribute("processingOrders", orderDAO.getOrdersByStatus("Processing"));
            request.setAttribute("shippedOrders", orderDAO.getOrdersByStatus("Shipped"));
            request.setAttribute("deliveredOrders", orderDAO.getOrdersByStatus("Delivered"));

            // Forward to dashboard.jsp
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in admin dashboard", e);
            System.out.println("Error in admin dashboard: " + e.getMessage());
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        }
    }
} 