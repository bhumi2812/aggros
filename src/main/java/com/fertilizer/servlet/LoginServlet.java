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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    private final UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        User user = userDAO.getUserByEmail(email);
        System.out.println(email + " : " + password + " : " + user);
        
        if (user != null && password.equals(user.getPassword())) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
            if ("admin".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/home.jsp");
            }
        } else {
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
} 