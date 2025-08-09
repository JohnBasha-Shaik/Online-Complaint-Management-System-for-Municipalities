package com.municipal.department.service;

import com.municipal.department.domain.Department;
import com.municipal.department.domain.DepartmentStaff;
import com.municipal.department.repo.DepartmentRepository;
import com.municipal.department.repo.DepartmentStaffRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class DepartmentService {
    private final DepartmentRepository departmentRepository;
    private final DepartmentStaffRepository departmentStaffRepository;

    public DepartmentService(DepartmentRepository departmentRepository, DepartmentStaffRepository departmentStaffRepository) {
        this.departmentRepository = departmentRepository;
        this.departmentStaffRepository = departmentStaffRepository;
    }

    @Transactional
    public Department createDepartment(String name, String description) {
        departmentRepository.findByName(name).ifPresent(d -> { throw new IllegalArgumentException("Department exists"); });
        Department d = new Department();
        d.setName(name);
        d.setDescription(description);
        return departmentRepository.save(d);
    }

    public List<Department> listDepartments() {
        return departmentRepository.findAll();
    }

    @Transactional
    public DepartmentStaff assignStaff(Long departmentId, Long userId) {
        Department department = departmentRepository.findById(departmentId).orElseThrow();
        DepartmentStaff ds = new DepartmentStaff();
        ds.setDepartment(department);
        ds.setUserId(userId);
        return departmentStaffRepository.save(ds);
    }

    public List<DepartmentStaff> listStaff(Long departmentId) {
        return departmentStaffRepository.findByDepartmentId(departmentId);
    }
}