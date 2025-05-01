package com.pesticides.servlet;

import com.pesticides.dao.UserDAO;
import com.pesticides.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class UserLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        System.out.println("UserLoginServlet initialized.");
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("doPost called.");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        System.out.println("Received email: " + email);
        System.out.println("Received password: " + password);

        try {
            User user = userDAO.getUserByEmail(email);
            System.out.println("User fetched from DB: " + user);

            if (user != null) {
                System.out.println("User found: " + user.getEmail());
                System.out.println("Stored password: " + user.getPassword());
                System.out.println("Entered password: " + password);
            } else {
                System.out.println("No user found with email: " + email);
            }

            if (user != null && user.getPassword().equals(password)) {
                System.out.println("Password match. Logging in...");

                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                System.out.println("User session set.");

                if ("admin".equals(user.getRole())) {
                    System.out.println("Redirecting to admin dashboard.");
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
                } else {
                    System.out.println("Redirecting to index.jsp.");
                    response.sendRedirect(request.getContextPath() + "/index.jsp");
                }
            } else {
                System.out.println("Invalid credentials.");
                request.setAttribute("error", "Invalid email or password");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.out.println("Exception during login: " + e.getMessage());
            e.printStackTrace(); // To print full stack trace
            request.setAttribute("error", "Login failed: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
