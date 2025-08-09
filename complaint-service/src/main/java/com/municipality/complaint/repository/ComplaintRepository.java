package com.municipality.complaint.repository;

import com.municipality.complaint.entity.Complaint;
import com.municipality.complaint.entity.ComplaintCategory;
import com.municipality.complaint.entity.ComplaintStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface ComplaintRepository extends JpaRepository<Complaint, Long> {
    
    List<Complaint> findByCitizenUsername(String citizenUsername);
    
    List<Complaint> findByCategory(ComplaintCategory category);
    
    List<Complaint> findByStatus(ComplaintStatus status);
    
    List<Complaint> findByAssignedDepartment(String assignedDepartment);
    
    List<Complaint> findByAssignedStaff(String assignedStaff);
    
    @Query("SELECT c FROM Complaint c WHERE c.citizenUsername = :username ORDER BY c.createdAt DESC")
    List<Complaint> findComplaintsByUsernameOrderByCreatedAt(@Param("username") String username);
    
    @Query("SELECT c FROM Complaint c WHERE c.status = :status ORDER BY c.createdAt ASC")
    List<Complaint> findByStatusOrderByCreatedAt(@Param("status") ComplaintStatus status);
    
    @Query("SELECT c FROM Complaint c WHERE c.assignedDepartment = :department AND c.status IN :statuses")
    List<Complaint> findByDepartmentAndStatusIn(@Param("department") String department, @Param("statuses") List<ComplaintStatus> statuses);
    
    @Query("SELECT c FROM Complaint c WHERE c.createdAt BETWEEN :startDate AND :endDate")
    List<Complaint> findComplaintsBetweenDates(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
    
    @Query("SELECT COUNT(c) FROM Complaint c WHERE c.status = :status")
    long countByStatus(@Param("status") ComplaintStatus status);
    
    @Query("SELECT COUNT(c) FROM Complaint c WHERE c.category = :category")
    long countByCategory(@Param("category") ComplaintCategory category);
}