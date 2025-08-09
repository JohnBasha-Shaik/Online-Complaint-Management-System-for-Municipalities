package com.municipality.user.dto;

import com.municipality.user.entity.Role;

import java.time.LocalDateTime;

public class UserResponseDto {
    
    private Long id;
    private String name;
    private String email;
    private String username;
    private Role role;
    private LocalDateTime createdAt;
    private Boolean isActive;

    // Constructors
    public UserResponseDto() {}

    public UserResponseDto(Long id, String name, String email, String username, Role role, 
                          LocalDateTime createdAt, Boolean isActive) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.username = username;
        this.role = role;
        this.createdAt = createdAt;
        this.isActive = isActive;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }
}