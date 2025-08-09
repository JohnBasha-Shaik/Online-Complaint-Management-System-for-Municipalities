package com.municipality.user.entity;

public enum UserRole {
    CITIZEN("Citizen"),
    MUNICIPAL_STAFF("Municipal Staff"),
    ADMIN("Administrator");
    
    private final String displayName;
    
    UserRole(String displayName) {
        this.displayName = displayName;
    }
    
    public String getDisplayName() {
        return displayName;
    }
}