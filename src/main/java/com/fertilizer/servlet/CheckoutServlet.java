package com.fertilizer.servlet;

import com.fertilizer.dao.UserDAO;
import com.fertilizer.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    
    private final UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Get updated user data from database
        user = userDAO.getUserById(user.getId());
        session.setAttribute("user", user);
        
        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        
        if (address != null && !address.trim().isEmpty() && 
            phone != null && !phone.trim().isEmpty()) {
            
            if (userDAO.updateUserAddress(user.getId(), address, phone)) {
                // Update user object in session
                user.setAddress(address);
                user.setPhone(phone);
                session.setAttribute("user", user);
                
                response.sendRedirect(request.getContextPath() + "/booking.jsp");
            } else {
                request.setAttribute("error", "Failed to update address. Please try again.");
                request.getRequestDispatcher("/checkout.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Please fill in all fields");
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
        }
    }
} 