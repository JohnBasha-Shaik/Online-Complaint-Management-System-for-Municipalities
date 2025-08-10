package com.municipal.complaint.repo;

import com.municipal.complaint.domain.Complaint;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ComplaintRepository extends JpaRepository<Complaint, Long> {
    List<Complaint> findByCreatedByUserId(Long userId);
    List<Complaint> findByAssignedDepartmentId(Long departmentId);
}