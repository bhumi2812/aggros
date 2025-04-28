package com.fertilizer.servlet;

import com.fertilizer.dao.ProductDAO;
import com.fertilizer.model.Product;
import com.fertilizer.model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ProductDAO productDAO;
    
    public HomeServlet() {
        this.productDAO = new ProductDAO();
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
        
        // Get featured products (you can modify this logic to get specific featured products)
        List<Product> featuredProducts = productDAO.getAllProducts();
        
        request.setAttribute("featuredProducts", featuredProducts);
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }
} 