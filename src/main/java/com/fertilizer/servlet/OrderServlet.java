package com.fertilizer.servlet;

import com.fertilizer.dao.CartDAO;
import com.fertilizer.dao.OrderDAO;
import com.fertilizer.model.CartItem;
import com.fertilizer.model.Order;
import com.fertilizer.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/orders")
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final OrderDAO orderDAO;
    private final CartDAO cartDAO;
    
    public OrderServlet() {
        this.orderDAO = new OrderDAO();
        this.cartDAO = new CartDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        List<Order> orders = orderDAO.getOrdersByUser(user);
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("orders.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        if ("create".equals(action)) {
            List<CartItem> cart = cartDAO.getCart(user);
            if (cart != null && !cart.isEmpty()) {
                if (orderDAO.createOrder(user, cart)) {
                    cartDAO.clearCart(user);
                    session.setAttribute("successMessage", "Order placed successfully!");
                } else {
                    session.setAttribute("errorMessage", "Failed to place order. Please try again.");
                }
            } else {
                session.setAttribute("errorMessage", "Your cart is empty.");
            }
        }
        
        response.sendRedirect("orders");
    }
} 