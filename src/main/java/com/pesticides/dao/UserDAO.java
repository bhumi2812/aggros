package com.pesticides.dao;

import com.pesticides.model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {
    private final DatabaseConnection dbConnection;
    
    public UserDAO() {
        dbConnection = new DatabaseConnection();
        System.out.println("UserDAO initialized");
    }
    
    public User getUserByEmail(String email) {
        System.out.println("Getting user by email: " + email);
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            System.out.println("Executing query: " + sql);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    System.out.println("User found in database");
                    return createUserFromResultSet(rs);
                } else {
                    System.out.println("No user found with email: " + email);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting user by email: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    public void createUser(User user) throws SQLException {
        System.out.println("Creating new user: " + user.getEmail());
        String sql = "INSERT INTO users (username, email, password, role, phone, address) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getRole());
            stmt.setString(5, user.getPhone());
            stmt.setString(6, user.getAddress());
            System.out.println("Executing insert query");
            stmt.executeUpdate();
            System.out.println("User created successfully");
        } catch (SQLException e) {
            System.out.println("Error creating user: " + e.getMessage());
            throw e;
        }
    }
    
    public void updateUser(User user) throws SQLException {
        System.out.println("Updating user: " + user.getEmail());
        String sql = "UPDATE users SET username = ?, email = ?, password = ?, role = ?, phone = ?, address = ? WHERE id = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getRole());
            stmt.setString(5, user.getPhone());
            stmt.setString(6, user.getAddress());
            stmt.setInt(7, user.getId());
            System.out.println("Executing update query");
            stmt.executeUpdate();
            System.out.println("User updated successfully");
        } catch (SQLException e) {
            System.out.println("Error updating user: " + e.getMessage());
            throw e;
        }
    }
    
    private User createUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setRole(rs.getString("role"));
        user.setPhone(rs.getString("phone"));
        user.setAddress(rs.getString("address"));
        System.out.println("Created user object from result set");
        return user;
    }
} 