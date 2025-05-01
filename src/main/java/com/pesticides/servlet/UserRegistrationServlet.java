package com.pesticides.servlet;

import com.pesticides.dao.UserDAO;
import com.pesticides.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class UserRegistrationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        
        try {
            // Check if user already exists
            User existingUser = userDAO.getUserByEmail(email);
            if (existingUser != null) {
                request.setAttribute("error", "Email already registered");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            
            // Create new user
            User newUser = new User();
            newUser.setUsername(username);
            newUser.setEmail(email);
            newUser.setPassword(password);
            newUser.setRole("user"); // Default role
            newUser.setPhone(phone);
            newUser.setAddress(address);
            
            userDAO.createUser(newUser);
            
            // Redirect to login page with success message
            request.setAttribute("message", "Registration successful! Please login.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Registration failed: " + e.getMessage());
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
} 