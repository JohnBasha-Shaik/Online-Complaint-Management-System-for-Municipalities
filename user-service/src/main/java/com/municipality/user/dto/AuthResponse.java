package com.municipality.user.dto;

import com.municipality.user.entity.UserRole;

public class AuthResponse {
    
    private String token;
    private String username;
    private String name;
    private String email;
    private UserRole role;
    private String message;
    
    // Constructors
    public AuthResponse() {}
    
    public AuthResponse(String token, String username, String name, String email, UserRole role, String message) {
        this.token = token;
        this.username = username;
        this.name = name;
        this.email = email;
        this.role = role;
        this.message = message;
    }
    
    // Getters and Setters
    public String getToken() {
        return token;
    }
    
    public void setToken(String token) {
        this.token = token;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public UserRole getRole() {
        return role;
    }
    
    public void setRole(UserRole role) {
        this.role = role;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
}