package com.fertilizer.dao;

import com.fertilizer.config.DatabaseConfig;
import com.fertilizer.model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {
    
    private static final String INSERT_USER = "INSERT INTO users (name, email, password, role, address, phone) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String GET_USER_BY_EMAIL = "SELECT * FROM users WHERE email = ?";
    private static final String GET_USER_BY_ID = "SELECT * FROM users WHERE id = ?";
    private static final String UPDATE_USER_ADDRESS = "UPDATE users SET address = ?, phone = ? WHERE id = ?";
    
    public boolean createUser(User user) {
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(INSERT_USER)) {
            
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getRole() != null ? user.getRole() : "user");
            stmt.setString(5, user.getAddress());
            stmt.setString(6, user.getPhone());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error creating user: " + e.getMessage());
            return false;
        }
    }
    
    public User getUserByEmail(String email) {
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_USER_BY_EMAIL)) {
            
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
            	System.out.println("rs.next worked");
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                user.setAddress(rs.getString("address"));
                user.setPhone(rs.getString("phone"));
                
                return user;
            }
        } catch (SQLException e) {
            System.err.println("Error getting user by email: " + e.getMessage());
        }
        return null;
    }
    
    public User getUserById(int id) {
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(GET_USER_BY_ID)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                user.setAddress(rs.getString("address"));
                user.setPhone(rs.getString("phone"));
                return user;
            }
        } catch (SQLException e) {
            System.err.println("Error getting user by id: " + e.getMessage());
        }
        return null;
    }
    
    public boolean updateUserAddress(int userId, String address, String phone) {
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_USER_ADDRESS)) {
            
            stmt.setString(1, address);
            stmt.setString(2, phone);
            stmt.setInt(3, userId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating user address: " + e.getMessage());
            return false;
        }
    }
} 