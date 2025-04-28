package com.fertilizer.model;

import java.util.Date;
import java.util.List;

public class Order {
    private int id;
    private User user;
    private double totalAmount;
    private String status;
    private Date createdAt;
    private List<OrderItem> items;

    public Order() {}

    public Order(int id, User user, double totalAmount, String status, Date createdAt) {
        this.id = id;
        this.user = user;
        this.totalAmount = totalAmount;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public List<OrderItem> getItems() {
        return items;
    }

    public void setItems(List<OrderItem> items) {
        this.items = items;
    }
} 