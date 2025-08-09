package com.municipality.complaint.dto;

import com.municipality.complaint.entity.ComplaintCategory;
import com.municipality.complaint.entity.ComplaintPriority;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public class ComplaintRequest {
    
    @NotBlank(message = "Description is required")
    @Size(min = 10, max = 1000, message = "Description must be between 10 and 1000 characters")
    private String description;
    
    @NotNull(message = "Category is required")
    private ComplaintCategory category;
    
    private String location;
    
    private ComplaintPriority priority = ComplaintPriority.MEDIUM;
    
    // Constructors
    public ComplaintRequest() {}
    
    public ComplaintRequest(String description, ComplaintCategory category, String location, ComplaintPriority priority) {
        this.description = description;
        this.category = category;
        this.location = location;
        this.priority = priority;
    }
    
    // Getters and Setters
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public ComplaintCategory getCategory() {
        return category;
    }
    
    public void setCategory(ComplaintCategory category) {
        this.category = category;
    }
    
    public String getLocation() {
        return location;
    }
    
    public void setLocation(String location) {
        this.location = location;
    }
    
    public ComplaintPriority getPriority() {
        return priority;
    }
    
    public void setPriority(ComplaintPriority priority) {
        this.priority = priority;
    }
}