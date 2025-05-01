package com.pesticides.servlet;

import com.pesticides.dao.ProductDAO;
import com.pesticides.model.Product;
import jakarta.servlet.RequestDispatcher;
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
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/admin/products")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class ProductServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ProductServlet.class.getName());
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
                throw new ServletException("Failed to create upload directory: " + uploadPath);
            } else {
                LOGGER.info("Created upload directory: " + uploadPath);
            }
        }
        
        // Ensure the directory is writable
        if (!uploadDir.canWrite()) {
            LOGGER.severe("Upload directory is not writable: " + uploadPath);
            throw new ServletException("Upload directory is not writable: " + uploadPath);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            LOGGER.info("Received action: " + action);
            
            if (action == null) {
                // Get all products and set them as request attribute
                List<Product> products = productDAO.getAllProducts();
                LOGGER.info("Retrieved " + products.size() + " products from database");
                
                // Set products in both request and session for consistency
                request.setAttribute("products", products);
                request.getSession().setAttribute("products", products);
                
                // Forward to products.jsp to display the list
                RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/products.jsp");
                if (dispatcher != null) {
                    dispatcher.forward(request, response);
                } else {
                    LOGGER.severe("Could not find dispatcher for /admin/products.jsp");
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Could not find products page");
                }
                return;
            }
            
            switch (action) {
                case "edit":
                    try {
                        int editId = Integer.parseInt(request.getParameter("id"));
                        Product productToEdit = productDAO.getProductById(editId);
                        if (productToEdit != null) {
                            request.setAttribute("product", productToEdit);
                            RequestDispatcher editDispatcher = request.getRequestDispatcher("/admin/edit-product.jsp");
                            if (editDispatcher != null) {
                                editDispatcher.forward(request, response);
                            } else {
                                LOGGER.severe("Could not find dispatcher for /admin/edit-product.jsp");
                                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Could not find edit page");
                            }
                        } else {
                            request.setAttribute("error", "Product not found");
                            response.sendRedirect(request.getContextPath() + "/admin/products");
                        }
                    } catch (NumberFormatException e) {
                        LOGGER.log(Level.SEVERE, "Invalid product ID format", e);
                        request.setAttribute("error", "Invalid product ID");
                        response.sendRedirect(request.getContextPath() + "/admin/products");
                    }
                    break;
                    
                case "delete":
                    try {
                        int deleteId = Integer.parseInt(request.getParameter("id"));
                        if (productDAO.deleteProduct(deleteId)) {
                            request.setAttribute("success", "Product deleted successfully");
                        } else {
                            request.setAttribute("error", "Failed to delete product");
                        }
                    } catch (NumberFormatException e) {
                        LOGGER.log(Level.SEVERE, "Invalid product ID format", e);
                        request.setAttribute("error", "Invalid product ID");
                    }
                    response.sendRedirect(request.getContextPath() + "/admin/products");
                    break;
                    
                default:
                    LOGGER.warning("Unknown action: " + action);
                    response.sendRedirect(request.getContextPath() + "/admin/products");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in doGet", e);
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect("products.jsp");
            return;
        }
        
        switch (action) {
            case "add":
                addProduct(request, response);
                break;
            case "edit":
                editProduct(request, response);
                break;
            default:
                response.sendRedirect("products.jsp");
        }
    }

    private void addProduct(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Get form data
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String category = request.getParameter("category");
            String stockStr = request.getParameter("stock");
            
            LOGGER.info("Received form data: name=" + name + ", description=" + description + 
                       ", price=" + priceStr + ", category=" + category + ", stock=" + stockStr);

            // Validate required fields
            if (name == null || name.trim().isEmpty() ||
                description == null || description.trim().isEmpty() ||
                priceStr == null || priceStr.trim().isEmpty() ||
                category == null || category.trim().isEmpty() ||
                stockStr == null || stockStr.trim().isEmpty()) {
                request.setAttribute("error", "All fields are required");
                request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
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
                request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
                return;
            }
            
            // Handle file upload
            Part filePart = request.getPart("image");
            String fileName = getFileName(filePart);
            
            if (fileName == null || fileName.isEmpty()) {
                request.setAttribute("error", "Please select an image for the product");
                request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
                return;
            }

            // Generate unique filename
            String extension = fileName.substring(fileName.lastIndexOf("."));
            String uniqueFileName = UUID.randomUUID().toString() + extension;
            
            // Save file
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            String filePath = uploadPath + File.separator + uniqueFileName;
            
            LOGGER.info("Saving file to: " + filePath);
            
            try (InputStream fileContent = filePart.getInputStream()) {
                Files.copy(fileContent, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
            }
            
            // Create product
            Product product = new Product();
            product.setName(name.trim());
            product.setDescription(description.trim());
            product.setPrice(price);
            product.setCategory(category);
            product.setStock(stock);
            product.setImageUrl(UPLOAD_DIR + "/" + uniqueFileName);
            
            LOGGER.info("Attempting to create product: " + product);
            
            // Save product
            if (productDAO.addProduct(product)) {
                LOGGER.info("Product created successfully");
                request.setAttribute("success", "Product added successfully!");
            } else {
                LOGGER.warning("Failed to create product");
                request.setAttribute("error", "Failed to add product. Please try again.");
            }
            
            // Get updated product list
            List<Product> products = productDAO.getAllProducts();
            request.setAttribute("totalProducts", products);
            
            request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error adding product", e);
            request.setAttribute("error", "An error occurred while adding the product: " + e.getMessage());
            request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
        }
    }

    private void editProduct(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Get form data
            int productId = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String category = request.getParameter("category");
            String stockStr = request.getParameter("stock");
            String ratingStr = request.getParameter("rating");
            
            LOGGER.info("Received form data for edit: id=" + productId + ", name=" + name + 
                       ", description=" + description + ", price=" + priceStr + 
                       ", category=" + category + ", stock=" + stockStr + ", rating=" + ratingStr);

            // Validate required fields
            if (name == null || name.trim().isEmpty() ||
                description == null || description.trim().isEmpty() ||
                priceStr == null || priceStr.trim().isEmpty() ||
                category == null || category.trim().isEmpty() ||
                stockStr == null || stockStr.trim().isEmpty()) {
                request.setAttribute("error", "All fields are required");
                response.sendRedirect(request.getContextPath() + "/admin/products?action=edit&id=" + productId);
                return;
            }

            double price;
            int stock;
            double rating = 0.0;
            try {
                price = Double.parseDouble(priceStr);
                stock = Integer.parseInt(stockStr);
                if (ratingStr != null && !ratingStr.trim().isEmpty()) {
                    rating = Double.parseDouble(ratingStr);
                }
                if (price <= 0 || stock < 0 || rating < 0 || rating > 5) {
                    throw new NumberFormatException();
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid numeric values");
                response.sendRedirect(request.getContextPath() + "/admin/products?action=edit&id=" + productId);
                return;
            }
            
            // Get existing product
            Product existingProduct = productDAO.getProductById(productId);
            if (existingProduct == null) {
                request.setAttribute("error", "Product not found");
                response.sendRedirect(request.getContextPath() + "/admin/products");
                return;
            }
            
            // Handle file upload
            Part filePart = request.getPart("image");
            String fileName = getFileName(filePart);
            String imageUrl = existingProduct.getImageUrl();
            
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
                
                imageUrl = UPLOAD_DIR + "/" + uniqueFileName;
            }
            
            // Update product
            Product product = new Product();
            product.setId(productId);
            product.setName(name.trim());
            product.setDescription(description.trim());
            product.setPrice(price);
            product.setCategory(category);
            product.setStock(stock);
            product.setImageUrl(imageUrl);
            product.setRating(rating);
            
            LOGGER.info("Attempting to update product: " + product);
            
            // Update product
            if (productDAO.updateProduct(product)) {
                LOGGER.info("Product updated successfully");
                request.setAttribute("success", "Product updated successfully!");
            } else {
                LOGGER.warning("Failed to update product");
                request.setAttribute("error", "Failed to update product. Please try again.");
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/products");
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating product", e);
            request.setAttribute("error", "An error occurred while updating the product: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }

    private String getFileName(Part part) {
        String fileName = null;
        String contentDisposition = part.getHeader("content-disposition");
        String[] items = contentDisposition.split(";");
        for (String item : items) {
            if (item.trim().startsWith("filename")) {
                fileName = item.substring(item.indexOf("=") + 2, item.length() - 1);
            }
        }
        return fileName;
    }
} 