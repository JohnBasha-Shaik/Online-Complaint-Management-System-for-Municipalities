package com.municipal.department.repo;

import com.municipal.department.domain.DepartmentStaff;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface DepartmentStaffRepository extends JpaRepository<DepartmentStaff, Long> {
    List<DepartmentStaff> findByDepartmentId(Long departmentId);
    List<DepartmentStaff> findByUserId(Long userId);
}