<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.pesticides.util.DBUtil" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Database Test</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            line-height: 1.6;
        }
        .success {
            color: green;
        }
        .error {
            color: red;
        }
        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h1>Database Connection Test</h1>
    
    <%
        Connection conn = null;
        try {
            // Test database connection
            out.println("<h2>Testing Database Connection</h2>");
            conn = DBUtil.getConnection();
            out.println("<p class='success'>Database connection successful!</p>");
            
            // Get database info
            DatabaseMetaData metaData = conn.getMetaData();
            out.println("<p>Database Product Name: " + metaData.getDatabaseProductName() + "</p>");
            out.println("<p>Database Product Version: " + metaData.getDatabaseProductVersion() + "</p>");
            
            // Check if tables exist
            out.println("<h2>Checking Tables</h2>");
            String[] tables = {"products", "users", "orders", "order_items", "cart"};
            for (String table : tables) {
                ResultSet rs = metaData.getTables(null, null, table, new String[]{"TABLE"});
                if (rs.next()) {
                    out.println("<p class='success'>Table '" + table + "' exists</p>");
                } else {
                    out.println("<p class='error'>Table '" + table + "' does not exist</p>");
                }
            }
            
            // Show products table structure
            out.println("<h2>Products Table Structure</h2>");
            ResultSet columns = metaData.getColumns(null, null, "products", null);
            out.println("<table>");
            out.println("<tr><th>Column Name</th><th>Data Type</th><th>Size</th><th>Nullable</th></tr>");
            while (columns.next()) {
                out.println("<tr>");
                out.println("<td>" + columns.getString("COLUMN_NAME") + "</td>");
                out.println("<td>" + columns.getString("TYPE_NAME") + "</td>");
                out.println("<td>" + columns.getString("COLUMN_SIZE") + "</td>");
                out.println("<td>" + columns.getString("IS_NULLABLE") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            
            // Show sample products
            out.println("<h2>Sample Products</h2>");
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM products LIMIT 5");
            out.println("<table>");
            out.println("<tr><th>ID</th><th>Name</th><th>Description</th><th>Price</th><th>Category</th><th>Stock</th></tr>");
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getInt("id") + "</td>");
                out.println("<td>" + rs.getString("name") + "</td>");
                out.println("<td>" + rs.getString("description") + "</td>");
                out.println("<td>" + rs.getDouble("price") + "</td>");
                out.println("<td>" + rs.getString("category") + "</td>");
                out.println("<td>" + rs.getInt("stock") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            
        } catch (Exception e) {
            out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
            e.printStackTrace(new java.io.PrintWriter(out));
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    %>
    
    <p><a href="init-db">Initialize Database</a></p>
    <p><a href="admin/products.jsp">Go to Product Management</a></p>
</body>
</html> 