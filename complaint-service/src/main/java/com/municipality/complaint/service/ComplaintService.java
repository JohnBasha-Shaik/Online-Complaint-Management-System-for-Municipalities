package com.municipality.complaint.service;

import com.municipality.complaint.dto.ComplaintRequest;
import com.municipality.complaint.entity.*;
import com.municipality.complaint.repository.ComplaintRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class ComplaintService {

    @Autowired
    private ComplaintRepository complaintRepository;

    public Complaint createComplaint(ComplaintRequest request, String citizenUsername, String citizenName, String citizenEmail) {
        Complaint complaint = new Complaint();
        complaint.setDescription(request.getDescription());
        complaint.setCategory(request.getCategory());
        complaint.setLocation(request.getLocation());
        complaint.setPriority(request.getPriority());
        complaint.setCitizenUsername(citizenUsername);
        complaint.setCitizenName(citizenName);
        complaint.setCitizenEmail(citizenEmail);
        complaint.setStatus(ComplaintStatus.SUBMITTED);
        
        return complaintRepository.save(complaint);
    }

    public Optional<Complaint> getComplaintById(Long id) {
        return complaintRepository.findById(id);
    }

    public List<Complaint> getAllComplaints() {
        return complaintRepository.findAll();
    }

    public List<Complaint> getComplaintsByUser(String username) {
        return complaintRepository.findComplaintsByUsernameOrderByCreatedAt(username);
    }

    public List<Complaint> getComplaintsByStatus(ComplaintStatus status) {
        return complaintRepository.findByStatusOrderByCreatedAt(status);
    }

    public List<Complaint> getComplaintsByCategory(ComplaintCategory category) {
        return complaintRepository.findByCategory(category);
    }

    public List<Complaint> getComplaintsByDepartment(String department) {
        return complaintRepository.findByAssignedDepartment(department);
    }

    public List<Complaint> getComplaintsByStaff(String staff) {
        return complaintRepository.findByAssignedStaff(staff);
    }

    public Complaint updateComplaintStatus(Long id, ComplaintStatus status) {
        Optional<Complaint> complaintOptional = complaintRepository.findById(id);
        if (complaintOptional.isPresent()) {
            Complaint complaint = complaintOptional.get();
            complaint.setStatus(status);
            if (status == ComplaintStatus.RESOLVED && complaint.getResolvedAt() == null) {
                complaint.setResolvedAt(LocalDateTime.now());
            }
            return complaintRepository.save(complaint);
        }
        return null;
    }

    public Complaint assignComplaintToDepartment(Long id, String department) {
        Optional<Complaint> complaintOptional = complaintRepository.findById(id);
        if (complaintOptional.isPresent()) {
            Complaint complaint = complaintOptional.get();
            complaint.setAssignedDepartment(department);
            if (complaint.getStatus() == ComplaintStatus.SUBMITTED) {
                complaint.setStatus(ComplaintStatus.UNDER_REVIEW);
            }
            return complaintRepository.save(complaint);
        }
        return null;
    }

    public Complaint assignComplaintToStaff(Long id, String staff) {
        Optional<Complaint> complaintOptional = complaintRepository.findById(id);
        if (complaintOptional.isPresent()) {
            Complaint complaint = complaintOptional.get();
            complaint.setAssignedStaff(staff);
            if (complaint.getStatus() == ComplaintStatus.UNDER_REVIEW) {
                complaint.setStatus(ComplaintStatus.IN_PROGRESS);
            }
            return complaintRepository.save(complaint);
        }
        return null;
    }

    public Complaint updateComplaintPriority(Long id, ComplaintPriority priority) {
        Optional<Complaint> complaintOptional = complaintRepository.findById(id);
        if (complaintOptional.isPresent()) {
            Complaint complaint = complaintOptional.get();
            complaint.setPriority(priority);
            return complaintRepository.save(complaint);
        }
        return null;
    }

    public Complaint addCommentToComplaint(Long complaintId, String comment, String authorUsername, String authorName, String authorRole) {
        Optional<Complaint> complaintOptional = complaintRepository.findById(complaintId);
        if (complaintOptional.isPresent()) {
            Complaint complaint = complaintOptional.get();
            ComplaintComment complaintComment = new ComplaintComment(comment, authorUsername, authorName, authorRole, complaint);
            complaint.getComments().add(complaintComment);
            return complaintRepository.save(complaint);
        }
        return null;
    }

    public List<Complaint> getComplaintsBetweenDates(LocalDateTime startDate, LocalDateTime endDate) {
        return complaintRepository.findComplaintsBetweenDates(startDate, endDate);
    }

    public long getComplaintCountByStatus(ComplaintStatus status) {
        return complaintRepository.countByStatus(status);
    }

    public long getComplaintCountByCategory(ComplaintCategory category) {
        return complaintRepository.countByCategory(category);
    }

    public boolean deleteComplaint(Long id) {
        if (complaintRepository.existsById(id)) {
            complaintRepository.deleteById(id);
            return true;
        }
        return false;
    }
}