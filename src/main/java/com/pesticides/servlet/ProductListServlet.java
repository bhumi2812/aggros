package com.pesticides.servlet;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.ArrayList;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.pesticides.dao.ProductDAO;
import com.pesticides.model.Product;

@WebServlet("/products")
public class ProductListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ProductListServlet.class.getName());
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        try {
            productDAO = new ProductDAO();
            LOGGER.info("ProductListServlet initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize ProductListServlet", e);
            throw new ServletException("Failed to initialize ProductListServlet", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get all products
            List<Product> allProducts = productDAO.getAllProducts();
            
            // Group products by category
            Map<String, List<Product>> productsByCategory = new HashMap<>();
            
            // Initialize categories
            String[] categories = {"Fertilizers", "Pesticides", "Seeds", "Liquids", "Organic Products"};
            for (String category : categories) {
                productsByCategory.put(category, new ArrayList<>());
            }
            
            // Add "Other" category for any uncategorized products
            productsByCategory.put("Other", new ArrayList<>());
            
            // Group products by category
            for (Product product : allProducts) {
                String category = product.getCategory();
                if (category != null && !category.trim().isEmpty()) {
                    // Normalize category name
                    category = category.trim();
                    // Check if it matches any of our predefined categories
                    boolean matched = false;
                    for (String predefinedCategory : categories) {
                        if (category.equalsIgnoreCase(predefinedCategory)) {
                            productsByCategory.get(predefinedCategory).add(product);
                            matched = true;
                            break;
                        }
                    }
                    if (!matched) {
                        productsByCategory.get("Other").add(product);
                    }
                } else {
                    productsByCategory.get("Other").add(product);
                }
            }
            
            // Set the products in the session
            request.getSession().setAttribute("productsByCategory", productsByCategory);
            
            // Forward to products.jsp
            request.getRequestDispatcher("/products.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving products", e);
            request.setAttribute("error", "An error occurred while retrieving products. Please try again.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} 