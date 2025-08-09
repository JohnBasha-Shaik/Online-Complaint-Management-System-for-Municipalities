package com.municipality.complaint.repository;

import com.municipality.complaint.entity.Complaint;
import com.municipality.complaint.entity.ComplaintCategory;
import com.municipality.complaint.entity.ComplaintStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ComplaintRepository extends JpaRepository<Complaint, Long> {
    List<Complaint> findByCitizenId(Long citizenId);
    List<Complaint> findByStatus(ComplaintStatus status);
    List<Complaint> findByCategory(ComplaintCategory category);
    List<Complaint> findByAssignedDepartment(String department);
    List<Complaint> findByAssignedStaffId(Long staffId);
    
    @Query("SELECT c FROM Complaint c WHERE c.citizenId = :citizenId AND c.status = :status")
    List<Complaint> findByCitizenIdAndStatus(@Param("citizenId") Long citizenId, @Param("status") ComplaintStatus status);
    
    @Query("SELECT c FROM Complaint c WHERE c.category = :category AND c.status = :status")
    List<Complaint> findByCategoryAndStatus(@Param("category") ComplaintCategory category, @Param("status") ComplaintStatus status);
}