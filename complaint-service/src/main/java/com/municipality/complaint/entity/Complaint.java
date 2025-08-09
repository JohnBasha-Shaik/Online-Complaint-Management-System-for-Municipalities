package com.municipality.complaint.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "complaints")
public class Complaint {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotBlank(message = "Description is required")
    @Size(min = 10, max = 1000, message = "Description must be between 10 and 1000 characters")
    @Column(nullable = false, length = 1000)
    private String description;
    
    @NotNull(message = "Category is required")
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ComplaintCategory category;
    
    @NotNull(message = "Status is required")
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ComplaintStatus status;
    
    @Column(name = "citizen_username", nullable = false)
    private String citizenUsername;
    
    @Column(name = "citizen_name")
    private String citizenName;
    
    @Column(name = "citizen_email")
    private String citizenEmail;
    
    @Column(name = "assigned_department")
    private String assignedDepartment;
    
    @Column(name = "assigned_staff")
    private String assignedStaff;
    
    @Column(name = "location")
    private String location;
    
    @Column(name = "priority")
    @Enumerated(EnumType.STRING)
    private ComplaintPriority priority = ComplaintPriority.MEDIUM;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @Column(name = "resolved_at")
    private LocalDateTime resolvedAt;
    
    @OneToMany(mappedBy = "complaint", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<ComplaintComment> comments = new ArrayList<>();
    
    // Constructors
    public Complaint() {}
    
    public Complaint(String description, ComplaintCategory category, String citizenUsername, String citizenName, String citizenEmail) {
        this.description = description;
        this.category = category;
        this.citizenUsername = citizenUsername;
        this.citizenName = citizenName;
        this.citizenEmail = citizenEmail;
        this.status = ComplaintStatus.SUBMITTED;
    }
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (status == null) {
            status = ComplaintStatus.SUBMITTED;
        }
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
        if (status == ComplaintStatus.RESOLVED && resolvedAt == null) {
            resolvedAt = LocalDateTime.now();
        }
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
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
    
    public ComplaintStatus getStatus() {
        return status;
    }
    
    public void setStatus(ComplaintStatus status) {
        this.status = status;
    }
    
    public String getCitizenUsername() {
        return citizenUsername;
    }
    
    public void setCitizenUsername(String citizenUsername) {
        this.citizenUsername = citizenUsername;
    }
    
    public String getCitizenName() {
        return citizenName;
    }
    
    public void setCitizenName(String citizenName) {
        this.citizenName = citizenName;
    }
    
    public String getCitizenEmail() {
        return citizenEmail;
    }
    
    public void setCitizenEmail(String citizenEmail) {
        this.citizenEmail = citizenEmail;
    }
    
    public String getAssignedDepartment() {
        return assignedDepartment;
    }
    
    public void setAssignedDepartment(String assignedDepartment) {
        this.assignedDepartment = assignedDepartment;
    }
    
    public String getAssignedStaff() {
        return assignedStaff;
    }
    
    public void setAssignedStaff(String assignedStaff) {
        this.assignedStaff = assignedStaff;
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
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public LocalDateTime getResolvedAt() {
        return resolvedAt;
    }
    
    public void setResolvedAt(LocalDateTime resolvedAt) {
        this.resolvedAt = resolvedAt;
    }
    
    public List<ComplaintComment> getComments() {
        return comments;
    }
    
    public void setComments(List<ComplaintComment> comments) {
        this.comments = comments;
    }
}