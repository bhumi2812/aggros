package com.fertilizer.dao;

import com.fertilizer.config.DatabaseConfig;
import com.fertilizer.model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
    
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setStock(rs.getInt("stock"));
                product.setImageUrl(rs.getString("image_url"));
                product.setCategory(rs.getString("category"));
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return products;
    }
    
    public List<Product> getProductsByCategory(String category) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE category = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, category);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setStock(rs.getInt("stock"));
                product.setImageUrl(rs.getString("image_url"));
                product.setCategory(rs.getString("category"));
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return products;
    }
    
    public Product getProductById(int id) {
        String sql = "SELECT * FROM products WHERE id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setStock(rs.getInt("stock"));
                product.setImageUrl(rs.getString("image_url"));
                product.setCategory(rs.getString("category"));
                return product;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    public boolean createProduct(Product product) {
        String sql = "INSERT INTO products (name, description, price, stock, image_url, category) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, product.getName());
            stmt.setString(2, product.getDescription());
            stmt.setDouble(3, product.getPrice());
            stmt.setInt(4, product.getStock());
            stmt.setString(5, product.getImageUrl());
            stmt.setString(6, product.getCategory());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error creating product: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateProduct(Product product) {
        String sql = "UPDATE products SET name = ?, description = ?, price = ?, " +
                    "stock = ?, image_url = ?, category = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, product.getName());
            stmt.setString(2, product.getDescription());
            stmt.setDouble(3, product.getPrice());
            stmt.setInt(4, product.getStock());
            stmt.setString(5, product.getImageUrl());
            stmt.setString(6, product.getCategory());
            stmt.setInt(7, product.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating product: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteProduct(int id) {
        String sql = "DELETE FROM products WHERE id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting product: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateStock(int productId, int newStock) {
        String sql = "UPDATE products SET stock = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, newStock);
            stmt.setInt(2, productId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating product stock: " + e.getMessage());
            return false;
        }
    }
} 