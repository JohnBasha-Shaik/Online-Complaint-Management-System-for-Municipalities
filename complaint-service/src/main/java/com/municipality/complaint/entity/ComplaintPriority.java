package com.municipality.complaint.entity;

public enum ComplaintPriority {
    LOW("Low"),
    MEDIUM("Medium"),
    HIGH("High"),
    URGENT("Urgent");
    
    private final String displayName;
    
    ComplaintPriority(String displayName) {
        this.displayName = displayName;
    }
    
    public String getDisplayName() {
        return displayName;
    }
}