package com.fertilizer.dao;

import com.fertilizer.config.DatabaseConfig;
import com.fertilizer.model.CartItem;
import com.fertilizer.model.Product;
import com.fertilizer.model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {
    
    public boolean saveCart(User user, List<CartItem> cart) {
        String sql = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?) " +
                    "ON DUPLICATE KEY UPDATE quantity = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            // First, clear existing cart items for this user
            clearCart(user);
            
            // Then insert new cart items
            for (CartItem item : cart) {
                stmt.setInt(1, user.getId());
                stmt.setInt(2, item.getProduct().getId());
                stmt.setInt(3, item.getQuantity());
                stmt.setInt(4, item.getQuantity());
                stmt.addBatch();
            }
            
            stmt.executeBatch();
            return true;
        } catch (SQLException e) {
            System.err.println("Error saving cart: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public List<CartItem> getCart(User user) {
        List<CartItem> cart = new ArrayList<>();
        String sql = "SELECT c.product_id, c.quantity, p.* FROM cart c " +
                    "JOIN products p ON c.product_id = p.id " +
                    "WHERE c.user_id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, user.getId());
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
                
                CartItem item = new CartItem(product, rs.getInt("quantity"));
                cart.add(item);
            }
        } catch (SQLException e) {
            System.err.println("Error getting cart: " + e.getMessage());
            e.printStackTrace();
        }
        
        return cart;
    }
    
    public boolean clearCart(User user) {
        String sql = "DELETE FROM cart WHERE user_id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, user.getId());
            int rowsAffected = stmt.executeUpdate();
            
            return rowsAffected >= 0; // Return true if the operation was successful
        } catch (SQLException e) {
            System.err.println("Error clearing cart: " + e.getMessage());
            return false;
        }
    }
} 