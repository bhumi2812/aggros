package com.fertilizer.servlet;

import com.fertilizer.dao.CartDAO;
import com.fertilizer.model.CartItem;
import com.fertilizer.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final CartDAO cartDAO;
    
    public CartServlet() {
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
        
        // Get cart items from database
        List<CartItem> cart = cartDAO.getCart(user);
        
        // Calculate total
        double total = 0.0;
        if (cart != null) {
            for (CartItem item : cart) {
                total += item.getProduct().getPrice() * item.getQuantity();
            }
        }
        
        request.setAttribute("cart", cart);
        request.setAttribute("total", total);
        request.getRequestDispatcher("cart.jsp").forward(request, response);
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
        if (action != null) {
            switch (action) {
                case "update":
                    int productId = Integer.parseInt(request.getParameter("productId"));
                    int quantity = Integer.parseInt(request.getParameter("quantity"));
                    
                    List<CartItem> cart = cartDAO.getCart(user);
                    if (cart != null) {
                        for (CartItem item : cart) {
                            if (item.getProduct().getId() == productId) {
                                item.setQuantity(quantity);
                                break;
                            }
                        }
                        cartDAO.saveCart(user, cart);
                    }
                    break;
                    
                case "remove":
                    int removeProductId = Integer.parseInt(request.getParameter("productId"));
                    cart = cartDAO.getCart(user);
                    if (cart != null) {
                        cart.removeIf(item -> item.getProduct().getId() == removeProductId);
                        cartDAO.saveCart(user, cart);
                    }
                    break;
                    
                case "clear":
                    cartDAO.clearCart(user);
                    break;
            }
        }
        
        response.sendRedirect("cart");
    }
} 