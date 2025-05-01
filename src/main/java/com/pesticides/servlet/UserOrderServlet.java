package com.pesticides.servlet;

import com.pesticides.dao.OrderDAO;
import com.pesticides.model.Order;
import com.pesticides.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/pesticides/orders")
public class UserOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(UserOrderServlet.class.getName());
    private OrderDAO orderDAO;
    
    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
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
        
        try {
            // Get orders for the current user
            List<Order> orders = orderDAO.getOrdersByUserId(user.getId());
            request.setAttribute("orders", orders);
            
            // Forward to orders.jsp to display the list
            request.getRequestDispatcher("/orders.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving user orders", e);
            session.setAttribute("errorMessage", "An error occurred while retrieving your orders: " + e.getMessage());
            request.getRequestDispatcher("/orders.jsp").forward(request, response);
        }
    }
} 