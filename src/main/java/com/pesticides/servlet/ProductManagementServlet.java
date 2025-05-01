package com.pesticides.servlet;

import com.pesticides.dao.ProductDAO;
import com.pesticides.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/admin/product-management")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class ProductManagementServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ProductManagementServlet.class.getName());
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "uploads";
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        
        // Create upload directory if it doesn't exist
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            boolean created = uploadDir.mkdirs();
            if (!created) {
                LOGGER.severe("Failed to create upload directory: " + uploadPath);
            } else {
                LOGGER.info("Created upload directory: " + uploadPath);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }
        
        switch (action) {
            case "update":
                updateProduct(request, response);
                break;
            case "delete":
                deleteProduct(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Get form data
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String category = request.getParameter("category");
            String stockStr = request.getParameter("stock");
            
            LOGGER.info("Updating product: id=" + id + ", name=" + name);

            // Validate required fields
            if (name == null || name.trim().isEmpty() ||
                description == null || description.trim().isEmpty() ||
                priceStr == null || priceStr.trim().isEmpty() ||
                category == null || category.trim().isEmpty() ||
                stockStr == null || stockStr.trim().isEmpty()) {
                request.setAttribute("error", "All fields are required");
                request.getRequestDispatcher("/admin/edit-product.jsp?id=" + id).forward(request, response);
                return;
            }

            double price;
            int stock;
            try {
                price = Double.parseDouble(priceStr);
                stock = Integer.parseInt(stockStr);
                if (price <= 0 || stock < 0) {
                    throw new NumberFormatException();
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Price must be positive and stock must be non-negative");
                request.getRequestDispatcher("/admin/edit-product.jsp?id=" + id).forward(request, response);
                return;
            }
            
            // Get existing product
            Product product = productDAO.getProductById(id);
            if (product == null) {
                request.setAttribute("error", "Product not found");
                request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
                return;
            }
            
            // Handle file upload if a new image is provided
            Part filePart = request.getPart("image");
            String fileName = getFileName(filePart);
            
            if (fileName != null && !fileName.isEmpty()) {
                // Generate unique filename
                String extension = fileName.substring(fileName.lastIndexOf("."));
                String uniqueFileName = UUID.randomUUID().toString() + extension;
                
                // Save file
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                String filePath = uploadPath + File.separator + uniqueFileName;
                
                LOGGER.info("Saving new image to: " + filePath);
                
                try (InputStream fileContent = filePart.getInputStream()) {
                    Files.copy(fileContent, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                }
                
                // Update product image URL
                product.setImageUrl(UPLOAD_DIR + "/" + uniqueFileName);
            }
            
            // Update product details
            product.setName(name.trim());
            product.setDescription(description.trim());
            product.setPrice(price);
            product.setCategory(category);
            product.setStock(stock);
            
            LOGGER.info("Attempting to update product: " + product);
            
            // Save product
            if (productDAO.updateProduct(product)) {
                LOGGER.info("Product updated successfully");
                request.getSession().setAttribute("success", "Product updated successfully!");
            } else {
                LOGGER.warning("Failed to update product");
                request.getSession().setAttribute("error", "Failed to update product. Please try again.");
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/products");
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating product", e);
            request.setAttribute("error", "An error occurred while updating the product: " + e.getMessage());
            request.getRequestDispatcher("/admin/edit-product.jsp?id=" + request.getParameter("id")).forward(request, response);
        }
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            LOGGER.info("Deleting product: id=" + id);
            
            // Get product to delete
            Product product = productDAO.getProductById(id);
            if (product == null) {
                request.setAttribute("error", "Product not found");
                request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
                return;
            }
            
            // Delete product
            if (productDAO.deleteProduct(id)) {
                LOGGER.info("Product deleted successfully");
                request.getSession().setAttribute("success", "Product deleted successfully!");
            } else {
                LOGGER.warning("Failed to delete product");
                request.getSession().setAttribute("error", "Failed to delete product. Please try again.");
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/products");
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error deleting product", e);
            request.setAttribute("error", "An error occurred while deleting the product: " + e.getMessage());
            request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
        }
    }

    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] items = contentDisposition.split(";");
        for (String item : items) {
            if (item.trim().startsWith("filename")) {
                return item.substring(item.indexOf("=") + 2, item.length() - 1);
            }
        }
        return null;
    }
}
