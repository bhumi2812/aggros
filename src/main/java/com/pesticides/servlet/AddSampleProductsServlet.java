package com.pesticides.servlet;

import com.pesticides.dao.ProductDAO;
import com.pesticides.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/add-sample-products")
public class AddSampleProductsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO;
    
    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Clear existing products first
            productDAO.clearAllProducts();
            
            // Fertilizers
            addProduct("NPK Fertilizer", 
                      "Complete NPK fertilizer with balanced nutrients (10-10-10) for all types of crops. Promotes healthy growth and high yields.",
                      29.99, 100, "Fertilizers", "images/fertilizer1.jpg", 4.5);
            
            addProduct("Organic Compost", 
                      "100% natural organic compost made from decomposed plant materials. Improves soil structure and fertility.",
                      19.99, 150, "Fertilizers", "images/fertilizer2.jpg", 4.8);
            
            addProduct("Bone Meal", 
                      "Natural phosphorus-rich fertilizer made from ground animal bones. Perfect for root development and flowering.",
                      24.99, 80, "Fertilizers", "images/fertilizer3.jpg", 4.2);
            
            addProduct("Potassium Sulfate", 
                      "High-quality potassium fertilizer for improved fruit quality and disease resistance. Essential for flowering and fruiting plants.",
                      34.99, 60, "Fertilizers", "images/fertilizer4.jpg", 4.6);
            
            addProduct("Calcium Nitrate", 
                      "Water-soluble calcium and nitrogen fertilizer. Prevents blossom end rot and promotes strong cell walls.",
                      27.99, 70, "Fertilizers", "images/fertilizer5.jpg", 4.7);
            
            // Pesticides
            addProduct("Neem Oil Spray", 
                      "Organic pesticide made from neem tree extracts. Controls pests while being safe for beneficial insects.",
                      15.99, 120, "Pesticides", "images/pesticide1.jpg", 4.7);
            
            addProduct("Pyrethrin Spray", 
                      "Natural insecticide derived from chrysanthemum flowers. Effective against a wide range of garden pests.",
                      22.99, 90, "Pesticides", "images/pesticide2.jpg", 4.3);
            
            addProduct("Diatomaceous Earth", 
                      "Natural powder made from fossilized algae. Controls crawling insects without chemicals.",
                      12.99, 200, "Pesticides", "images/pesticide3.jpg", 4.6);
            
            addProduct("Bacillus Thuringiensis", 
                      "Biological insecticide targeting caterpillars and larvae. Safe for beneficial insects and pollinators.",
                      18.99, 85, "Pesticides", "images/pesticide4.jpg", 4.8);
            
            addProduct("Copper Fungicide", 
                      "Organic fungicide for controlling fungal diseases. Effective against blight, mildew, and leaf spot.",
                      25.99, 45, "Pesticides", "images/pesticide5.jpg", 4.5);
            
            // Seeds
            addProduct("Heirloom Tomato Seeds", 
                      "Premium heirloom tomato seeds. Produces large, juicy fruits with exceptional flavor.",
                      8.99, 300, "Seeds", "images/seed1.jpg", 4.9);
            
            addProduct("Organic Basil Seeds", 
                      "Certified organic basil seeds. Grows into aromatic plants perfect for culinary use.",
                      6.99, 250, "Seeds", "images/seed2.jpg", 4.4);
            
            addProduct("Hybrid Cucumber Seeds", 
                      "High-yield cucumber seeds. Disease-resistant and perfect for home gardens.",
                      7.99, 180, "Seeds", "images/seed3.jpg", 4.7);
            
            addProduct("Bell Pepper Seeds", 
                      "Colorful bell pepper seeds producing sweet, crisp fruits. Available in red, yellow, and green varieties.",
                      9.99, 150, "Seeds", "images/seed4.jpg", 4.6);
            
            addProduct("Carrot Seeds", 
                      "Premium carrot seeds for sweet, crunchy roots. Perfect for both spring and fall planting.",
                      5.99, 200, "Seeds", "images/seed5.jpg", 4.8);
            
            // Liquids
            addProduct("Liquid Seaweed Fertilizer", 
                      "Concentrated liquid fertilizer made from seaweed. Rich in micronutrients and growth hormones.",
                      18.99, 60, "Liquids", "images/liquid1.jpg", 4.8);
            
            addProduct("Fish Emulsion", 
                      "Organic liquid fertilizer made from fish byproducts. High in nitrogen and trace elements.",
                      16.99, 70, "Liquids", "images/liquid2.jpg", 4.5);
            
            addProduct("Humic Acid Solution", 
                      "Concentrated humic acid for soil conditioning. Improves nutrient uptake and soil structure.",
                      21.99, 50, "Liquids", "images/liquid3.jpg", 4.6);
            
            addProduct("Foliar Feed Spray", 
                      "Complete foliar fertilizer for quick nutrient absorption through leaves. Ideal for stressed plants.",
                      24.99, 40, "Liquids", "images/liquid4.jpg", 4.7);
            
            addProduct("Root Stimulator", 
                      "Specialized liquid formula for promoting strong root development. Contains beneficial bacteria.",
                      19.99, 55, "Liquids", "images/liquid5.jpg", 4.9);
            
            // Organic Products
            addProduct("Vermicompost", 
                      "Premium organic compost produced by earthworms. Rich in beneficial microorganisms.",
                      14.99, 100, "Organic Products", "images/organic1.jpg", 4.9);
            
            addProduct("Biochar", 
                      "Activated charcoal for soil improvement. Enhances water retention and nutrient availability.",
                      27.99, 40, "Organic Products", "images/organic2.jpg", 4.7);
            
            addProduct("Mycorrhizal Fungi", 
                      "Beneficial fungi that form symbiotic relationships with plant roots. Improves nutrient absorption.",
                      19.99, 30, "Organic Products", "images/organic3.jpg", 4.8);
            
            addProduct("Organic Mulch", 
                      "Natural mulch made from shredded bark and leaves. Retains moisture and suppresses weeds.",
                      12.99, 120, "Organic Products", "images/organic4.jpg", 4.6);
            
            addProduct("Compost Tea", 
                      "Liquid extract of compost containing beneficial microorganisms. Improves soil health naturally.",
                      16.99, 65, "Organic Products", "images/organic5.jpg", 4.7);
            
            request.setAttribute("message", "Sample products added successfully!");
            response.sendRedirect(request.getContextPath() + "/admin/products");
            
        } catch (Exception e) {
            request.setAttribute("error", "Error adding sample products: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }
    
    private void addProduct(String name, String description, double price, int stock, 
                          String category, String imageUrl, double rating) {
        Product product = new Product();
        product.setName(name);
        product.setDescription(description);
        product.setPrice(price);
        product.setStock(stock);
        product.setCategory(category);
        product.setImageUrl(imageUrl);
        product.setRating(rating);
        
        productDAO.addProduct(product);
    }
} 