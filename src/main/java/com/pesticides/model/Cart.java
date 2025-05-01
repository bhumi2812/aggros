package com.pesticides.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Cart {
    private static final Logger LOGGER = Logger.getLogger(Cart.class.getName());
    private Map<Integer, CartItem> items;
    private double totalAmount;

    public Cart() {
        this.items = new HashMap<>();
        this.totalAmount = 0.0;
    }

    public void addItem(Product product, int quantity) {
        if (items.containsKey(product.getId())) {
            CartItem existingItem = items.get(product.getId());
            existingItem.setQuantity(existingItem.getQuantity() + quantity);
        } else {
            CartItem newItem = new CartItem(product, quantity);
            items.put(product.getId(), newItem);
        }
        calculateTotal();
        LOGGER.info("Added product to cart: " + product.getName());
    }

    public void removeItem(int productId) {
        items.remove(productId);
        calculateTotal();
        LOGGER.info("Removed product from cart: " + productId);
    }

    public void updateQuantity(int productId, int quantity) {
        if (items.containsKey(productId)) {
            CartItem item = items.get(productId);
            item.setQuantity(quantity);
            calculateTotal();
            LOGGER.info("Updated quantity for product: " + productId + " to " + quantity);
        }
    }

    public List<CartItem> getItems() {
        return new ArrayList<>(items.values());
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public int getTotalItems() {
        return items.size();
    }

    public void clear() {
        items.clear();
        totalAmount = 0.0;
        LOGGER.info("Cart cleared");
    }

    private void calculateTotal() {
        totalAmount = 0.0;
        for (CartItem item : items.values()) {
            totalAmount += item.getSubtotal();
        }
    }

    public static class CartItem {
        private Product product;
        private int quantity;

        public CartItem(Product product, int quantity) {
            this.product = product;
            this.quantity = quantity;
        }

        public Product getProduct() {
            return product;
        }

        public int getQuantity() {
            return quantity;
        }

        public void setQuantity(int quantity) {
            this.quantity = quantity;
        }

        public double getSubtotal() {
            return product.getPrice() * quantity;
        }
    }
} 