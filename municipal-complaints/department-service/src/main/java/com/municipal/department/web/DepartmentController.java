package com.municipal.department.web;

import com.municipal.department.domain.Department;
import com.municipal.department.domain.DepartmentStaff;
import com.municipal.department.service.DepartmentService;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/departments")
public class DepartmentController {

    private final DepartmentService departmentService;

    public DepartmentController(DepartmentService departmentService) {
        this.departmentService = departmentService;
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public Department create(@NotBlank @RequestParam String name, @RequestParam(required = false) String description) {
        return departmentService.createDepartment(name, description);
    }

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','STAFF','CITIZEN')")
    public List<Department> list() {
        return departmentService.listDepartments();
    }

    @PostMapping("/{id}/assign-staff")
    @PreAuthorize("hasAnyRole('ADMIN','STAFF')")
    public DepartmentStaff assignStaff(@PathVariable Long id, @NotNull @RequestParam Long userId) {
        return departmentService.assignStaff(id, userId);
    }

    @GetMapping("/{id}/staff")
    @PreAuthorize("hasAnyRole('ADMIN','STAFF')")
    public List<DepartmentStaff> listStaff(@PathVariable Long id) {
        return departmentService.listStaff(id);
    }
}