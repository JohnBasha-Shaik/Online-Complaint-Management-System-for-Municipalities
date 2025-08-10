package com.municipal.complaint.web;

import com.municipal.complaint.domain.Complaint;
import com.municipal.complaint.domain.ComplaintComment;
import com.municipal.complaint.service.ComplaintService;
import com.municipal.complaint.web.dto.ComplaintDtos;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/complaints")
public class ComplaintController {

    private final ComplaintService complaintService;

    public ComplaintController(ComplaintService complaintService) {
        this.complaintService = complaintService;
    }

    @PostMapping
    @PreAuthorize("hasRole('CITIZEN')")
    public Complaint create(@Valid @RequestBody ComplaintDtos.CreateComplaintRequest request, @org.springframework.security.core.annotation.AuthenticationPrincipal com.municipal.security.AuthenticatedUser user) {
        return complaintService.createComplaint(user.getUserId(), request);
    }

    @GetMapping("/my")
    @PreAuthorize("hasRole('CITIZEN')")
    public List<Complaint> myComplaints(@org.springframework.security.core.annotation.AuthenticationPrincipal com.municipal.security.AuthenticatedUser user) {
        return complaintService.getMyComplaints(user.getUserId());
    }

    @PostMapping("/{id}/assign")
    @PreAuthorize("hasAnyRole('STAFF','ADMIN')")
    public Complaint assign(@PathVariable Long id, @Valid @RequestBody ComplaintDtos.AssignDepartmentRequest req) {
        return complaintService.assignDepartment(id, req.departmentId);
    }

    @PostMapping("/{id}/status")
    @PreAuthorize("hasAnyRole('STAFF','ADMIN')")
    public Complaint updateStatus(@PathVariable Long id, @Valid @RequestBody ComplaintDtos.UpdateStatusRequest req) {
        return complaintService.updateStatus(id, req.status);
    }

    @PostMapping("/{id}/comments")
    @PreAuthorize("hasAnyRole('CITIZEN','STAFF','ADMIN')")
    public ComplaintComment addComment(@PathVariable Long id, @Valid @RequestBody ComplaintDtos.AddCommentRequest req,
                                       @org.springframework.security.core.annotation.AuthenticationPrincipal com.municipal.security.AuthenticatedUser user) {
        return complaintService.addComment(id, user.getUserId(), req.content);
    }

    @GetMapping("/{id}/comments")
    @PreAuthorize("hasAnyRole('CITIZEN','STAFF','ADMIN')")
    public List<ComplaintComment> listComments(@PathVariable Long id) {
        return complaintService.listComments(id);
    }
}