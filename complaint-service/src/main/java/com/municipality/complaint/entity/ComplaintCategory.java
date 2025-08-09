package com.municipality.complaint.entity;

public enum ComplaintCategory {
    WATER("Water Supply Issues"),
    SANITATION("Sanitation Issues"),
    ROADS("Road and Infrastructure Issues"),
    WASTE_MANAGEMENT("Waste Management"),
    ELECTRICITY("Electricity Issues"),
    DRAINAGE("Drainage Issues"),
    PUBLIC_SAFETY("Public Safety"),
    OTHER("Other Issues");
    
    private final String displayName;
    
    ComplaintCategory(String displayName) {
        this.displayName = displayName;
    }
    
    public String getDisplayName() {
        return displayName;
    }
}