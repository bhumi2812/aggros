package com.pesticides.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/init-db")
public class DatabaseInitServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(DatabaseInitServlet.class.getName());
    private static final String DB_URL = "jdbc:mysql://localhost:3306/";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // First, try to connect to MySQL server without specifying a database
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                LOGGER.info("Connected to MySQL server successfully");
                
                // Create the database if it doesn't exist
                try (Statement stmt = conn.createStatement()) {
                    stmt.executeUpdate("CREATE DATABASE IF NOT EXISTS agros_db");
                    LOGGER.info("Database 'agros_db' created or already exists");
                }
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Error connecting to MySQL server or creating database", e);
                response.getWriter().write("Error: " + e.getMessage() + 
                    "<br>Please make sure MySQL is running and the credentials are correct.<br>" +
                    "You may need to install MySQL or add it to your PATH.");
                return;
            }
            
            // Now connect to the specific database
            try (Connection conn = DriverManager.getConnection(DB_URL + "agros_db", DB_USER, DB_PASSWORD)) {
                LOGGER.info("Connected to 'agros_db' database successfully");
                
                // Read the SQL script
                StringBuilder sqlScript = new StringBuilder();
                try (BufferedReader reader = new BufferedReader(
                        new InputStreamReader(getClass().getClassLoader().getResourceAsStream("db/create_database.sql")))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        sqlScript.append(line).append("\n");
                    }
                }
                
                // Execute the SQL script
                try (Statement stmt = conn.createStatement()) {
                    // Split the script into individual statements
                    String[] statements = sqlScript.toString().split(";");
                    for (String statement : statements) {
                        if (!statement.trim().isEmpty()) {
                            // Skip the CREATE DATABASE and USE statements as we've already handled them
                            if (!statement.trim().toLowerCase().startsWith("create database") && 
                                !statement.trim().toLowerCase().startsWith("use")) {
                                stmt.execute(statement);
                                LOGGER.info("Executed SQL: " + statement);
                            }
                        }
                    }
                }
                
                response.getWriter().write("Database initialized successfully!<br>" +
                    "<a href='test-db.jsp'>Test Database Connection</a><br>" +
                    "<a href='admin/products.jsp'>Go to Product Management</a>");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error initializing database", e);
            response.getWriter().write("Error initializing database: " + e.getMessage());
        }
    }
} 