package com.pesticides.servlet;

import com.pesticides.dao.OrderDAO;
import com.pesticides.dao.CartDAO;
import com.pesticides.dao.ProductDAO;
import com.pesticides.model.Order;
import com.pesticides.model.OrderItem;
import com.pesticides.model.Cart;
import com.pesticides.model.CartItem;
import com.pesticides.model.Product;
import com.pesticides.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/process-booking")
public class ProcessOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ProcessOrderServlet.class.getName());
    private OrderDAO orderDAO;
    private CartDAO cartDAO;
    private ProductDAO productDAO;
    
    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        cartDAO = new CartDAO();
        productDAO = new ProductDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            // Get cart items
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null || cart.getItems().isEmpty()) {
                session.setAttribute("error", "Your cart is empty");
                response.sendRedirect(request.getContextPath() + "/cart.jsp");
                return;
            }
            
            // Get shipping details from request
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            
            // Validate shipping details
            if (name == null || name.trim().isEmpty() || 
                email == null || email.trim().isEmpty() || 
                address == null || address.trim().isEmpty()) {
                session.setAttribute("error", "Please provide all required shipping details");
                response.sendRedirect(request.getContextPath() + "/checkout.jsp");
                return;
            }
            
            // Create order
            Order order = new Order();
            order.setUserId(user.getId());
            order.setOrderDate(new Timestamp(new Date().getTime()));
            order.setStatus("Pending");
            order.setTotalAmount(calculateTotalAmount(cart.getItems()));
            
            // Set shipping details
            order.setShippingName(name);
            order.setShippingEmail(email);
            order.setShippingPhone(phone != null ? phone : "");
            order.setShippingAddress(address);
            
            // Create order items
            List<OrderItem> orderItems = new ArrayList<>();
            for (Cart.CartItem cartItem : cart.getItems()) {
                OrderItem orderItem = new OrderItem();
                orderItem.setProductId(cartItem.getProduct().getId());
                orderItem.setQuantity(cartItem.getQuantity());
                orderItem.setPrice(cartItem.getProduct().getPrice());
                orderItems.add(orderItem);
            }
            order.setItems(orderItems);
            
            // Save order
            if (orderDAO.createOrder(order)) {
                // Clear cart
                session.removeAttribute("cart");
                
                // Get the saved order with ID
                Order savedOrder = orderDAO.getOrderById(order.getId());
                session.setAttribute("currentOrder", savedOrder);
                session.setAttribute("success", "Order placed successfully!");
                
                // Forward to confirmation page
                response.sendRedirect(request.getContextPath() + "/process-booking.jsp");
            } else {
                session.setAttribute("error", "Failed to place order. Please try again.");
                response.sendRedirect(request.getContextPath() + "/cart.jsp");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing order", e);
            session.setAttribute("error", "An error occurred while processing your order");
            response.sendRedirect(request.getContextPath() + "/cart.jsp");
        }
    }

    private double calculateTotalAmount(List<Cart.CartItem> items) {
        return items.stream()
                .mapToDouble(item -> item.getProduct().getPrice() * item.getQuantity())
                .sum();
    }
} 