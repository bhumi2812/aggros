package com.pesticides.servlet;

import com.pesticides.dao.ProductDAO;
import com.pesticides.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/print-products")
public class PrintProductsServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(PrintProductsServlet.class.getName());
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            List<Product> products = productDAO.getAllProducts();
            
            // Print to console
            System.out.println("\n=== PRODUCT LIST ===");
            System.out.println("ID\tName\t\tCategory\tPrice\tStock");
            System.out.println("--------------------------------------------------");
            
            for (Product product : products) {
                System.out.printf("%d\t%-15s\t%-10s\t₹%.2f\t%d%n",
                    product.getId(),
                    product.getName(),
                    product.getCategory(),
                    product.getPrice(),
                    product.getStock()
                );
            }
            System.out.println("--------------------------------------------------");
            System.out.println("Total Products: " + products.size());
            
            // HTML output
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Product Details</title>");
            out.println("<style>");
            out.println("body { font-family: Arial, sans-serif; margin: 20px; }");
            out.println("table { border-collapse: collapse; width: 100%; }");
            out.println("th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }");
            out.println("th { background-color: #4CAF50; color: white; }");
            out.println("tr:nth-child(even) { background-color: #f2f2f2; }");
            out.println("</style>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Product Details</h1>");
            
            if (products.isEmpty()) {
                out.println("<p>No products found.</p>");
            } else {
                out.println("<table>");
                out.println("<tr>");
                out.println("<th>ID</th>");
                out.println("<th>Name</th>");
                out.println("<th>Description</th>");
                out.println("<th>Category</th>");
                out.println("<th>Price (₹)</th>");
                out.println("<th>Stock</th>");
                out.println("<th>Image URL</th>");
                out.println("</tr>");

                for (Product product : products) {
                    out.println("<tr>");
                    out.println("<td>" + product.getId() + "</td>");
                    out.println("<td>" + product.getName() + "</td>");
                    out.println("<td>" + product.getDescription() + "</td>");
                    out.println("<td>" + product.getCategory() + "</td>");
                    out.println("<td>₹" + String.format("%.2f", product.getPrice()) + "</td>");
                    out.println("<td>" + product.getStock() + "</td>");
                    out.println("<td>" + (product.getImageUrl() != null ? product.getImageUrl() : "No image") + "</td>");
                    out.println("</tr>");
                }
                
                out.println("</table>");
            }
            
            out.println("</body>");
            out.println("</html>");
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error printing products", e);
            System.out.println("Error occurred while fetching products: " + e.getMessage());
            out.println("<h2>Error occurred while fetching products</h2>");
            out.println("<p>" + e.getMessage() + "</p>");
        }
    }
} 