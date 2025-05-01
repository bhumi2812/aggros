package com.pesticides.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class AdminFilter implements Filter {

    @Override
    public void init(FilterConfig fConfig) throws ServletException {
        // Initialization code if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        // Allow access to login page and login servlet
        String requestURI = httpRequest.getRequestURI();
        if (requestURI.endsWith("login.jsp") || requestURI.endsWith("admin-login") || 
            requestURI.endsWith("admin-login.jsp")) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check if user is authenticated as admin
        if (session == null || session.getAttribute("admin") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/admin/login.jsp");
            return;
        }
        
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
} 