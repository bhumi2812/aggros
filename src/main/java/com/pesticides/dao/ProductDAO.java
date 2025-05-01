package com.pesticides.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.pesticides.model.Product;
import com.pesticides.util.DBUtil;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ProductDAO {
    private static final Logger LOGGER = Logger.getLogger(ProductDAO.class.getName());
    private Connection connection;

    public ProductDAO() {
        try {
            connection = DBUtil.getConnection();
            LOGGER.info("ProductDAO initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize ProductDAO", e);
            throw new RuntimeException("Failed to initialize ProductDAO", e);
        }
    }

    public Product getProductById(int productId) {
        String query = "SELECT * FROM products WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, productId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setStock(rs.getInt("stock"));
                product.setCategory(rs.getString("category"));
                product.setImageUrl(rs.getString("image_url"));
                product.setRating(rs.getDouble("rating"));
                return product;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting product by ID", e);
        }
        
        return null;
    }

    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM products ORDER BY category, name";
        
        try (PreparedStatement stmt = connection.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setStock(rs.getInt("stock"));
                product.setCategory(rs.getString("category"));
                product.setImageUrl(rs.getString("image_url"));
                product.setRating(rs.getDouble("rating"));
                products.add(product);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all products", e);
        }
        
        return products;
    }

    public boolean addProduct(Product product) {
        String query = "INSERT INTO products (name, description, price, category, stock, image_url, rating) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setString(1, product.getName());
            preparedStatement.setString(2, product.getDescription());
            preparedStatement.setDouble(3, product.getPrice());
            preparedStatement.setString(4, product.getCategory());
            preparedStatement.setInt(5, product.getStock());
            preparedStatement.setString(6, product.getImageUrl());
            preparedStatement.setDouble(7, product.getRating());
            int result = preparedStatement.executeUpdate();
            LOGGER.info("Product added successfully. Rows affected: " + result);
            return result > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding product", e);
            return false;
        }
    }

    public boolean updateProduct(Product product) {
        String query = "UPDATE products SET name = ?, description = ?, price = ?, category = ?, stock = ?, rating = ?" +
                      (product.getImageUrl() != null ? ", image_url = ?" : "") +
                      " WHERE id = ?";
        
        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setString(1, product.getName());
            preparedStatement.setString(2, product.getDescription());
            preparedStatement.setDouble(3, product.getPrice());
            preparedStatement.setString(4, product.getCategory());
            preparedStatement.setInt(5, product.getStock());
            preparedStatement.setDouble(6, product.getRating());
            
            if (product.getImageUrl() != null) {
                preparedStatement.setString(7, product.getImageUrl());
                preparedStatement.setInt(8, product.getId());
            } else {
                preparedStatement.setInt(7, product.getId());
            }
            
            int result = preparedStatement.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating product", e);
            return false;
        }
    }

    public boolean deleteProduct(int productId) {
        String query = "DELETE FROM products WHERE id = ?";
        
        try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setInt(1, productId);
            int result = preparedStatement.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting product", e);
            return false;
        }
    }

    public int getTotalProducts() {
        String query = "SELECT COUNT(*) as total FROM products";
        try (PreparedStatement stmt = connection.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting total products", e);
        }
        return 0;
    }

    public List<Product> getProductsByCategory(String category) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM products WHERE category = ? ORDER BY name";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, category);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setStock(rs.getInt("stock"));
                product.setCategory(rs.getString("category"));
                product.setImageUrl(rs.getString("image_url"));
                product.setRating(rs.getDouble("rating"));
                products.add(product);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting products by category", e);
        }
        
        return products;
    }

    public void clearAllProducts() {
        String query = "DELETE FROM products";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.executeUpdate();
            LOGGER.info("All products cleared from database");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error clearing products", e);
            throw new RuntimeException("Error clearing products", e);
        }
    }
} 