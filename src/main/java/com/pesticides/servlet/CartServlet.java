package com.pesticides.servlet;

import com.pesticides.dao.ProductDAO;
import com.pesticides.model.Cart;
import com.pesticides.model.CartItem;
import com.pesticides.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }
        
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        
        // Get or create cart
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        if (action != null) {
            switch (action) {
                case "add":
                    addToCart(request, response, cart);
                    break;
                case "update":
                    updateCart(request, response, cart);
                    break;
                case "remove":
                    removeFromCart(request, response, cart);
                    break;
                case "checkout":
                    // Redirect to checkout if cart is not empty
                    if (!cart.getItems().isEmpty()) {
                        response.sendRedirect(request.getContextPath() + "/checkout.jsp");
                        return;
                    }
                    break;
            }
        }
        
        // Redirect back to cart page
        response.sendRedirect(request.getContextPath() + "/cart.jsp");
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response, Cart cart) 
            throws IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            Product product = productDAO.getProductById(productId);
            if (product != null) {
                cart.addItem(product, quantity);
            }
        } catch (NumberFormatException e) {
            // Handle invalid input
        }
    }

    private void updateCart(HttpServletRequest request, HttpServletResponse response, Cart cart) 
            throws IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            cart.updateQuantity(productId, quantity);
        } catch (NumberFormatException e) {
            // Handle invalid input
        }
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response, Cart cart) 
            throws IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            cart.removeItem(productId);
        } catch (NumberFormatException e) {
            // Handle invalid input
        }
    }
} 