package com.municipality.complaint.entity;

public enum ComplaintStatus {
    SUBMITTED("Submitted"),
    UNDER_REVIEW("Under Review"),
    IN_PROGRESS("In Progress"),
    RESOLVED("Resolved"),
    CLOSED("Closed"),
    REJECTED("Rejected");
    
    private final String displayName;
    
    ComplaintStatus(String displayName) {
        this.displayName = displayName;
    }
    
    public String getDisplayName() {
        return displayName;
    }
}