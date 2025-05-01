package com.pesticides.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;

public class DBUtil {
    private static final Logger LOGGER = Logger.getLogger(DBUtil.class.getName());
    private static final String DB_URL = "jdbc:mysql://localhost:3306/fertilizer_db";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";
    private static Connection connection = null;

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            initializeDatabase();
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "MySQL JDBC Driver not found", e);
            throw new RuntimeException("MySQL JDBC Driver not found", e);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error initializing database", e);
            throw new RuntimeException("Failed to initialize database", e);
        }
    }

    private static void initializeDatabase() throws SQLException {
        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306", DB_USER, DB_PASSWORD);
             Statement stmt = conn.createStatement()) {
            
            // Create database if not exists
            stmt.execute("CREATE DATABASE IF NOT EXISTS fertilizer_db");
            stmt.execute("USE fertilizer_db");
            
            // Drop existing tables if they exist (in correct order to handle foreign keys)
            stmt.execute("DROP TABLE IF EXISTS cart");
            stmt.execute("DROP TABLE IF EXISTS order_items");
            stmt.execute("DROP TABLE IF EXISTS orders");
            stmt.execute("DROP TABLE IF EXISTS products");
            stmt.execute("DROP TABLE IF EXISTS users");
            
            // Create tables
            stmt.execute("CREATE TABLE users (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "username VARCHAR(50) NOT NULL, " +
                    "password VARCHAR(64) NOT NULL, " +
                    "email VARCHAR(100) NOT NULL UNIQUE, " +
                    "role VARCHAR(20) NOT NULL DEFAULT 'user'" +
                    ")");
            
            stmt.execute("CREATE TABLE products (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "name VARCHAR(100) NOT NULL, " +
                    "description TEXT, " +
                    "price DECIMAL(10,2) NOT NULL, " +
                    "stock INT NOT NULL, " +
                    "category VARCHAR(50) NOT NULL, " +
                    "image_url VARCHAR(255), " +
                    "rating DECIMAL(3,2) DEFAULT 0.00" +
                    ")");
            
            stmt.execute("CREATE TABLE cart (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT NOT NULL, " +
                    "product_id INT NOT NULL, " +
                    "quantity INT NOT NULL DEFAULT 1, " +
                    "FOREIGN KEY (user_id) REFERENCES users(id), " +
                    "FOREIGN KEY (product_id) REFERENCES products(id)" +
                    ")");
            
            stmt.execute("CREATE TABLE orders (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT NOT NULL, " +
                    "total_amount DECIMAL(10,2) NOT NULL, " +
                    "status VARCHAR(20) NOT NULL, " +
                    "order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "shipping_address TEXT, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "FOREIGN KEY (user_id) REFERENCES users(id)" +
                    ")");
            
            stmt.execute("CREATE TABLE order_items (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "order_id INT NOT NULL, " +
                    "product_id INT NOT NULL, " +
                    "quantity INT NOT NULL, " +
                    "price DECIMAL(10,2) NOT NULL, " +
                    "FOREIGN KEY (order_id) REFERENCES orders(id), " +
                    "FOREIGN KEY (product_id) REFERENCES products(id)" +
                    ")");
            
            // Insert sample data
            stmt.execute("INSERT INTO users (username, password, email, role) VALUES " +
                    "('admin', 'admin', 'admin@agros.com', 'admin'), " +
                    "('tarun', '123456', 'tarun@gmail.com', 'user')");
            
            // Insert sample products
            stmt.execute("INSERT INTO products (name, description, price, stock, category, image_url, rating) VALUES " +
                    "('Organic Fertilizer', 'Natural plant food for healthy growth', 29.99, 100, 'Fertilizers', 'images/fertilizer1.jpg', 4.5), " +
                    "('Pest Control Spray', 'Effective against common garden pests', 19.99, 50, 'Pesticides', 'images/pesticide1.jpg', 4.2), " +
                    "('Compost Mix', 'Rich organic compost for soil improvement', 24.99, 75, 'Organic Products', 'images/compost1.jpg', 4.7), " +
                    "('Tomato Seeds', 'High-yield tomato variety', 9.99, 200, 'Seeds', 'images/seeds1.jpg', 4.8), " +
                    "('Plant Growth Liquid', 'Concentrated plant growth formula', 15.99, 60, 'Liquids', 'images/liquid1.jpg', 4.3)");
            
            LOGGER.info("Database initialized successfully");
        }
    }

    public static Connection getConnection() {
        try {
            if (connection == null || connection.isClosed()) {
                connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            }
            return connection;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting database connection", e);
            throw new RuntimeException("Failed to get database connection", e);
        }
    }

    public static void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
                connection = null;
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing database connection", e);
            }
        }
    }
} 