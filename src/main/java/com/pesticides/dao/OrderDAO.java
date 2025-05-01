package com.pesticides.dao;

import com.pesticides.model.Order;
import com.pesticides.model.OrderItem;
import com.pesticides.model.Product;
import com.pesticides.model.User;
import com.pesticides.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class OrderDAO {
    private static final Logger LOGGER = Logger.getLogger(OrderDAO.class.getName());
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    private final DBUtil dbUtil;
    private final ProductDAO productDAO;
    private final UserDAO userDAO;

    public OrderDAO() {
        this.dbUtil = new DBUtil();
        this.productDAO = new ProductDAO();
        this.userDAO = new UserDAO();
    }

    public boolean createOrder(Order order) {
        String sql = "INSERT INTO orders (user_id, total_amount, status, order_date) VALUES (?, ?, ?, NOW())";
        
        try (Connection conn = dbUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, order.getUserId());
            pstmt.setDouble(2, order.getTotalAmount());
            pstmt.setString(3, order.getStatus());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows == 0) {
                return false;
            }
            
            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int orderId = generatedKeys.getInt(1);
                    order.setId(orderId);
                    
                    // Save order items
                    return saveOrderItems(order);
                }
            }
            
            return false;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating order", e);
            return false;
        }
    }

    private boolean saveOrderItems(Order order) {
        String sql = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = dbUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            for (OrderItem item : order.getItems()) {
                pstmt.setInt(1, order.getId());
                pstmt.setInt(2, item.getProductId());
                pstmt.setInt(3, item.getQuantity());
                pstmt.setDouble(4, item.getPrice());
                pstmt.addBatch();
            }
            
            pstmt.executeBatch();
            return true;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error saving order items", e);
            return false;
        }
    }

    public List<Order> getAllOrders() {
        return getOrdersByStatus(null);
    }

    public List<Order> getOrdersByStatus(String status) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.username, u.email " +
                     "FROM orders o " +
                     "JOIN users u ON o.user_id = u.id";
        
        if (status != null && !status.equals("all")) {
            sql += " WHERE o.status = ?";
        }
        
        sql += " ORDER BY o.order_date DESC";

        try (Connection conn = dbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            if (status != null && !status.equals("all")) {
                stmt.setString(1, status);
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setId(rs.getInt("id"));
                    order.setOrderDate(rs.getTimestamp("order_date"));
                    order.setTotalAmount(rs.getDouble("total_amount"));
                    order.setStatus(rs.getString("status"));
                    order.setShippingAddress(rs.getString("shipping_address"));
                    order.setCreatedAt(rs.getTimestamp("created_at"));

                    User user = new User();
                    user.setId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    order.setUser(user);

                    order.setItems(getOrderItems(order.getId()));
                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving orders", e);
        }
        return orders;
    }

    private List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, p.name, p.image_url " +
                     "FROM order_items oi " +
                     "JOIN products p ON oi.product_id = p.id " +
                     "WHERE oi.order_id = ?";

        try (Connection conn = dbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, orderId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setId(rs.getInt("id"));
                    item.setOrderId(orderId);
                    item.setProductId(rs.getInt("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setPrice(rs.getDouble("price"));

                    Product product = new Product();
                    product.setId(rs.getInt("product_id"));
                    product.setName(rs.getString("name"));
                    product.setImageUrl(rs.getString("image_url"));
                    item.setProduct(product);

                    items.add(item);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving order items", e);
        }
        return items;
    }

    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        
        try (Connection conn = dbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, orderId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating order status", e);
            return false;
        }
    }

    public Order getOrderById(int orderId) {
        String sql = "SELECT o.*, u.username, u.email " +
                     "FROM orders o " +
                     "JOIN users u ON o.user_id = u.id " +
                     "WHERE o.id = ?";

        try (Connection conn = dbUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, orderId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Order order = new Order();
                    order.setId(rs.getInt("id"));
                    order.setOrderDate(rs.getTimestamp("order_date"));
                    order.setTotalAmount(rs.getDouble("total_amount"));
                    order.setStatus(rs.getString("status"));
                    order.setShippingAddress(rs.getString("shipping_address"));
                    order.setCreatedAt(rs.getTimestamp("created_at"));

                    User user = new User();
                    user.setId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    order.setUser(user);

                    order.setItems(getOrderItems(order.getId()));
                    return order;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving order by ID", e);
        }
        return null;
    }

    public int getTotalOrders() {
        String query = "SELECT COUNT(*) as total FROM orders";
        try (PreparedStatement stmt = dbUtil.getConnection().prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting total orders", e);
        }
        return 0;
    }

    public double getTotalRevenue() {
        String query = "SELECT SUM(total_amount) as revenue FROM orders WHERE status = 'Delivered'";
        try (PreparedStatement stmt = dbUtil.getConnection().prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble("revenue");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting total revenue", e);
        }
        return 0.0;
    }

    public List<Order> getRecentOrders(int limit) {
        List<Order> orders = new ArrayList<>();
        String query = "SELECT o.*, u.username as user_name " +
                      "FROM orders o " +
                      "JOIN users u ON o.user_id = u.id " +
                      "ORDER BY o.created_at DESC LIMIT ?";
        
        try (PreparedStatement stmt = dbUtil.getConnection().prepareStatement(query)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setUserId(rs.getInt("user_id"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setShippingAddress(rs.getString("shipping_address"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setUserName(rs.getString("user_name"));
                
                // Get order items
                order.setItems(getOrderItems(order.getId()));
                
                orders.add(order);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting recent orders", e);
        }
        
        return orders;
    }

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String query = "SELECT o.*, u.username as user_name " +
                      "FROM orders o " +
                      "JOIN users u ON o.user_id = u.id " +
                      "WHERE o.user_id = ? " +
                      "ORDER BY o.created_at DESC";
        
        try (PreparedStatement stmt = dbUtil.getConnection().prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setUserId(rs.getInt("user_id"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setShippingAddress(rs.getString("shipping_address"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setUserName(rs.getString("user_name"));
                
                // Get order items
                order.setItems(getOrderItems(order.getId()));
                
                orders.add(order);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting orders for user: " + userId, e);
        }
        
        return orders;
    }
} 