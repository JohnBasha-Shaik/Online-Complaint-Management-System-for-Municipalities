package com.municipality.user.dto;

import com.municipality.user.model.Role;

public class AuthResponse {
    private String token;
    private String type = "Bearer";
    private String username;
    private String email;
    private String name;
    private Role role;

    // Default constructor
    public AuthResponse() {}

    // Constructor
    public AuthResponse(String token, String username, String email, String name, Role role) {
        this.token = token;
        this.username = username;
        this.email = email;
        this.name = name;
        this.role = role;
    }

    // Getters and Setters
    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }
}