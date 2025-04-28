package com.fertilizer.dao;

import com.fertilizer.config.DatabaseConfig;
import com.fertilizer.model.Order;
import com.fertilizer.model.OrderItem;
import com.fertilizer.model.Product;
import com.fertilizer.model.User;
import com.fertilizer.model.CartItem;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {
    private final ProductDAO productDAO;

    public OrderDAO() {
        this.productDAO = new ProductDAO();
    }

    public boolean createOrder(User user, List<CartItem> cartItems) {
        String orderSql = "INSERT INTO orders (user_id, total_amount, status) VALUES (?, ?, 'PENDING')";
        String orderItemSql = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConfig.getConnection()) {
            conn.setAutoCommit(false);
            
            try {
                // Create order
                double totalAmount = cartItems.stream()
                    .mapToDouble(item -> item.getProduct().getPrice() * item.getQuantity())
                    .sum();
                
                try (PreparedStatement orderStmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                    orderStmt.setInt(1, user.getId());
                    orderStmt.setDouble(2, totalAmount);
                    orderStmt.executeUpdate();
                    
                    ResultSet rs = orderStmt.getGeneratedKeys();
                    if (rs.next()) {
                        int orderId = rs.getInt(1);
                        
                        // Create order items
                        try (PreparedStatement itemStmt = conn.prepareStatement(orderItemSql)) {
                            for (CartItem cartItem : cartItems) {
                                itemStmt.setInt(1, orderId);
                                itemStmt.setInt(2, cartItem.getProduct().getId());
                                itemStmt.setInt(3, cartItem.getQuantity());
                                itemStmt.setDouble(4, cartItem.getProduct().getPrice());
                                itemStmt.addBatch();
                                
                                // Update product stock
                                productDAO.updateStock(cartItem.getProduct().getId(), 
                                    cartItem.getProduct().getStock() - cartItem.getQuantity());
                            }
                            itemStmt.executeBatch();
                        }
                    }
                }
                
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                System.err.println("Error creating order: " + e.getMessage());
                return false;
            }
        } catch (SQLException e) {
            System.err.println("Error creating order: " + e.getMessage());
            return false;
        }
    }

    public List<Order> getOrdersByUser(User user) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, oi.id as item_id, oi.product_id, oi.quantity, oi.price, " +
                    "p.name, p.description, p.image_url, p.category " +
                    "FROM orders o " +
                    "LEFT JOIN order_items oi ON o.id = oi.order_id " +
                    "LEFT JOIN products p ON oi.product_id = p.id " +
                    "WHERE o.user_id = ? " +
                    "ORDER BY o.created_at DESC";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, user.getId());
            ResultSet rs = stmt.executeQuery();
            
            Order currentOrder = null;
            while (rs.next()) {
                if (currentOrder == null || currentOrder.getId() != rs.getInt("id")) {
                    currentOrder = new Order();
                    currentOrder.setId(rs.getInt("id"));
                    currentOrder.setUser(user);
                    currentOrder.setTotalAmount(rs.getDouble("total_amount"));
                    currentOrder.setStatus(rs.getString("status"));
                    currentOrder.setCreatedAt(rs.getTimestamp("created_at"));
                    currentOrder.setItems(new ArrayList<>());
                    orders.add(currentOrder);
                }
                
                if (rs.getInt("item_id") > 0) {
                    OrderItem item = new OrderItem();
                    item.setId(rs.getInt("item_id"));
                    item.setOrder(currentOrder);
                    
                    Product product = new Product();
                    product.setId(rs.getInt("product_id"));
                    product.setName(rs.getString("name"));
                    product.setDescription(rs.getString("description"));
                    product.setImageUrl(rs.getString("image_url"));
                    product.setCategory(rs.getString("category"));
                    product.setPrice(rs.getDouble("price"));
                    
                    item.setProduct(product);
                    item.setQuantity(rs.getInt("quantity"));
                    item.setPrice(rs.getDouble("price"));
                    
                    currentOrder.getItems().add(item);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting orders: " + e.getMessage());
        }
        
        return orders;
    }
} 