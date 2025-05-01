package com.pesticides.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DatabaseConnection {
    private static final Logger LOGGER = Logger.getLogger(DatabaseConnection.class.getName());
    private static final String BASE_URL = "jdbc:mysql://localhost:3306";
    private static final String DB_URL = "jdbc:mysql://localhost:3306/agros_db";
    private static final String USER = "root";
    private static final String PASSWORD = "root";
    
    static {
        try {
            // Load MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Create database and table
            try (Connection conn = DriverManager.getConnection(BASE_URL, USER, PASSWORD);
                 Statement stmt = conn.createStatement()) {
                
                // Create database if not exists
                stmt.execute("CREATE DATABASE IF NOT EXISTS agros_db");
                stmt.execute("USE agros_db");
                
                // Create users table if not exists
                stmt.execute("CREATE TABLE IF NOT EXISTS users (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "username VARCHAR(50) NOT NULL, " +
                    "email VARCHAR(100) NOT NULL UNIQUE, " +
                    "password VARCHAR(255) NOT NULL, " +
                    "role VARCHAR(20) NOT NULL DEFAULT 'user', " +
                    "phone VARCHAR(15), " +
                    "address VARCHAR(255), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                ")");
                
                System.out.println("Database and table created successfully");
            }
        } catch (ClassNotFoundException | SQLException e) {
            LOGGER.log(Level.SEVERE, "Error initializing database", e);
            e.printStackTrace();
        }
    }
    
    public Connection getConnection() throws SQLException {
        try {
            return DriverManager.getConnection(DB_URL, USER, PASSWORD);
        } catch (SQLException e) {
            System.out.println("Error connecting to database: " + e.getMessage());
            throw e;
        }
    }
} 