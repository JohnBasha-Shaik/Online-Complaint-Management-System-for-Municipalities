package com.municipality.complaint.dto;

import com.municipality.complaint.entity.ComplaintCategory;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public class ComplaintCreateDto {
    
    @NotNull(message = "Category is required")
    private ComplaintCategory category;
    
    @NotBlank(message = "Description is required")
    @Size(min = 10, max = 1000, message = "Description must be between 10 and 1000 characters")
    private String description;

    // Constructors
    public ComplaintCreateDto() {}

    public ComplaintCreateDto(ComplaintCategory category, String description) {
        this.category = category;
        this.description = description;
    }

    // Getters and Setters
    public ComplaintCategory getCategory() {
        return category;
    }

    public void setCategory(ComplaintCategory category) {
        this.category = category;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}