package com.fertilizer.servlet;

import com.fertilizer.dao.CartDAO;
import com.fertilizer.dao.ProductDAO;
import com.fertilizer.model.CartItem;
import com.fertilizer.model.Product;
import com.fertilizer.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ProductDAO productDAO;
    private final CartDAO cartDAO;
    
    public ProductServlet() {
        this.productDAO = new ProductDAO();
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
        
        String category = request.getParameter("category");
        List<Product> products;
        
        if (category != null && !category.isEmpty()) {
            products = productDAO.getProductsByCategory(category);
        } else {
            products = productDAO.getAllProducts();
        }
        
        // Get unique categories for filter
        List<String> categories = new ArrayList<>();
        for (Product product : productDAO.getAllProducts()) {
            if (!categories.contains(product.getCategory())) {
                categories.add(product.getCategory());
            }
        }
        
        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("selectedCategory", category);
        request.getRequestDispatcher("products.jsp").forward(request, response);
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
        if ("addToCart".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            Product product = productDAO.getProductById(productId);
            if (product != null && product.getStock() >= quantity) {
                // Get existing cart or create new one
                List<CartItem> cart = cartDAO.getCart(user);
                if (cart == null) {
                    cart = new ArrayList<>();
                }
                
                // Check if product already in cart
                boolean found = false;
                for (CartItem item : cart) {
                    if (item.getProduct().getId() == productId) {
                        item.setQuantity(item.getQuantity() + quantity);
                        found = true;
                        break;
                    }
                }
                
                // If product not in cart, add it
                if (!found) {
                    cart.add(new CartItem(product, quantity));
                }
                
                // Save cart to database
                if (cartDAO.saveCart(user, cart)) {
                    session.setAttribute("successMessage", "Product added to cart successfully!");
                } else {
                    session.setAttribute("errorMessage", "Failed to add product to cart.");
                }
            } else {
                session.setAttribute("errorMessage", "Product not available or insufficient stock.");
            }
        } else if ("add".equals(action)) {
            Product product = new Product();
            product.setName(request.getParameter("name"));
            product.setCategory(request.getParameter("category"));
            product.setPrice(Double.parseDouble(request.getParameter("price")));
            product.setDescription(request.getParameter("description"));
            product.setStock(Integer.parseInt(request.getParameter("stock")));
            
            if (productDAO.createProduct(product)) {
                response.sendRedirect(request.getContextPath() + "/admin/products.jsp");
            } else {
                request.setAttribute("error", "Failed to add product");
                request.getRequestDispatcher("/admin/add-product.jsp").forward(request, response);
            }
        } else if ("update".equals(action)) {
            Product product = new Product();
            product.setId(Integer.parseInt(request.getParameter("id")));
            product.setName(request.getParameter("name"));
            product.setCategory(request.getParameter("category"));
            product.setPrice(Double.parseDouble(request.getParameter("price")));
            product.setDescription(request.getParameter("description"));
            product.setStock(Integer.parseInt(request.getParameter("stock")));
            
            if (productDAO.updateProduct(product)) {
                response.sendRedirect(request.getContextPath() + "/admin/products.jsp");
            } else {
                request.setAttribute("error", "Failed to update product");
                request.getRequestDispatcher("/admin/edit-product.jsp").forward(request, response);
            }
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            
            if (productDAO.deleteProduct(id)) {
                response.sendRedirect(request.getContextPath() + "/admin/products.jsp");
            } else {
                request.setAttribute("error", "Failed to delete product");
                request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
            }
        }
        
        response.sendRedirect("products");
    }
} 