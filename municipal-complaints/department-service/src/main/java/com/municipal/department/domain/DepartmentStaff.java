package com.municipal.department.domain;

import jakarta.persistence.*;

@Entity
@Table(name = "department_staff", uniqueConstraints = @UniqueConstraint(name = "uk_dept_staff", columnNames = {"department_id","user_id"}))
public class DepartmentStaff {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Long userId; // reference to user-service

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "department_id")
    private Department department;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public Department getDepartment() { return department; }
    public void setDepartment(Department department) { this.department = department; }
}