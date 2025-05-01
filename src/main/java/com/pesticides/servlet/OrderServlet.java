package com.pesticides.servlet;

import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.pesticides.dao.OrderDAO;
import com.pesticides.model.Order;

@WebServlet("/admin/orders")
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(OrderServlet.class.getName());
    private final OrderDAO orderDAO = new OrderDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Check if user is admin
            if (!isAdmin(request)) {
                response.sendRedirect("../login.jsp");
                return;
            }

            String status = request.getParameter("status");
            List<Order> orders;
            
            if (status != null && !status.equals("all")) {
                orders = orderDAO.getOrdersByStatus(status);
            } else {
                orders = orderDAO.getAllOrders();
            }
            
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
        } catch (Exception e) {
            logger.severe("Error retrieving orders: " + e.getMessage());
            request.setAttribute("error", "Failed to retrieve orders. Please try again.");
            request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Check if user is admin
            if (!isAdmin(request)) {
                response.sendRedirect("../login.jsp");
                return;
            }

            String orderIdStr = request.getParameter("orderId");
            String status = request.getParameter("status");
            
            if (orderIdStr == null || status == null) {
                throw new IllegalArgumentException("Missing required parameters");
            }
            
            int orderId = Integer.parseInt(orderIdStr);
            boolean success = orderDAO.updateOrderStatus(orderId, status);
            
            if (success) {
                request.setAttribute("success", "Order status updated successfully!");
            } else {
                request.setAttribute("error", "Failed to update order status. Please try again.");
            }
            
            response.sendRedirect("orders");
        } catch (Exception e) {
            logger.severe("Error updating order status: " + e.getMessage());
            request.setAttribute("error", "Failed to update order status. Please try again.");
            request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        // Check if user is logged in and is admin
        return request.getSession().getAttribute("user") != null && 
               (boolean) request.getSession().getAttribute("isAdmin");
    }
} 