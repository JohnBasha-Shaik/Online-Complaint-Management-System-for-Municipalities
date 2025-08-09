package com.municipality.complaint.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import java.time.LocalDateTime;

@Entity
@Table(name = "complaint_comments")
public class ComplaintComment {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotBlank(message = "Comment is required")
    @Size(min = 1, max = 500, message = "Comment must be between 1 and 500 characters")
    @Column(nullable = false, length = 500)
    private String comment;
    
    @Column(name = "author_username", nullable = false)
    private String authorUsername;
    
    @Column(name = "author_name")
    private String authorName;
    
    @Column(name = "author_role")
    private String authorRole;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "complaint_id", nullable = false)
    private Complaint complaint;
    
    // Constructors
    public ComplaintComment() {}
    
    public ComplaintComment(String comment, String authorUsername, String authorName, String authorRole, Complaint complaint) {
        this.comment = comment;
        this.authorUsername = authorUsername;
        this.authorName = authorName;
        this.authorRole = authorRole;
        this.complaint = complaint;
    }
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getComment() {
        return comment;
    }
    
    public void setComment(String comment) {
        this.comment = comment;
    }
    
    public String getAuthorUsername() {
        return authorUsername;
    }
    
    public void setAuthorUsername(String authorUsername) {
        this.authorUsername = authorUsername;
    }
    
    public String getAuthorName() {
        return authorName;
    }
    
    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }
    
    public String getAuthorRole() {
        return authorRole;
    }
    
    public void setAuthorRole(String authorRole) {
        this.authorRole = authorRole;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public Complaint getComplaint() {
        return complaint;
    }
    
    public void setComplaint(Complaint complaint) {
        this.complaint = complaint;
    }
}