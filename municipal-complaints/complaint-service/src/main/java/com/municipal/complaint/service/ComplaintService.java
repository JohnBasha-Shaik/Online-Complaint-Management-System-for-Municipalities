package com.municipal.complaint.service;

import com.municipal.complaint.domain.Complaint;
import com.municipal.complaint.domain.ComplaintComment;
import com.municipal.complaint.repo.ComplaintCommentRepository;
import com.municipal.complaint.repo.ComplaintRepository;
import com.municipal.complaint.web.dto.ComplaintDtos;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ComplaintService {

    private final ComplaintRepository complaintRepository;
    private final ComplaintCommentRepository commentRepository;

    public ComplaintService(ComplaintRepository complaintRepository, ComplaintCommentRepository commentRepository) {
        this.complaintRepository = complaintRepository;
        this.commentRepository = commentRepository;
    }

    private String currentUsername() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return auth != null ? auth.getName() : null;
    }

    @Transactional
    public Complaint createComplaint(Long userId, ComplaintDtos.CreateComplaintRequest req) {
        Complaint complaint = new Complaint();
        complaint.setCategory(req.category);
        complaint.setDescription(req.description);
        complaint.setCreatedByUserId(userId);
        complaint.setStatus(Complaint.Status.OPEN);
        return complaintRepository.save(complaint);
    }

    public List<Complaint> getMyComplaints(Long userId) {
        return complaintRepository.findByCreatedByUserId(userId);
    }

    @Transactional
    public Complaint assignDepartment(Long complaintId, Long departmentId) {
        Complaint c = complaintRepository.findById(complaintId).orElseThrow();
        c.setAssignedDepartmentId(departmentId);
        c.setStatus(Complaint.Status.IN_PROGRESS);
        return complaintRepository.save(c);
    }

    @Transactional
    public Complaint updateStatus(Long complaintId, Complaint.Status status) {
        Complaint c = complaintRepository.findById(complaintId).orElseThrow();
        c.setStatus(status);
        return complaintRepository.save(c);
    }

    @Transactional
    public ComplaintComment addComment(Long complaintId, Long authorUserId, String content) {
        Complaint c = complaintRepository.findById(complaintId).orElseThrow();
        if (!authorUserId.equals(c.getCreatedByUserId()) && c.getAssignedDepartmentId() == null) {
            throw new AccessDeniedException("Only owner or assigned staff can comment");
        }
        ComplaintComment comment = new ComplaintComment();
        comment.setComplaint(c);
        comment.setAuthorUserId(authorUserId);
        comment.setContent(content);
        return commentRepository.save(comment);
    }

    public List<ComplaintComment> listComments(Long complaintId) {
        return commentRepository.findByComplaintId(complaintId);
    }
}