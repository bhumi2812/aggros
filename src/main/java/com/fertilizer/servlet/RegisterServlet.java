package com.fertilizer.servlet;

import com.fertilizer.dao.UserDAO;
import com.fertilizer.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    private final UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate input
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            !password.equals(confirmPassword)) {
            
            request.setAttribute("error", "Invalid input or passwords do not match");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Check if email already exists
        if (userDAO.getUserByEmail(email) != null) {
            request.setAttribute("error", "Email already registered");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Create new user
        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(password); // Store password in plain text
        user.setRole("user");
        
        if (userDAO.createUser(user)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/register.jsp");
    }
} 