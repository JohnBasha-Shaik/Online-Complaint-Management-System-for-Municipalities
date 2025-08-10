package com.municipality.complaint.controller;

import com.municipality.complaint.dto.ComplaintCreateDto;
import com.municipality.complaint.dto.ComplaintResponseDto;
import com.municipality.complaint.dto.CommentDto;
import com.municipality.complaint.entity.ComplaintCategory;
import com.municipality.complaint.entity.ComplaintStatus;
import com.municipality.complaint.service.ComplaintService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/")
@CrossOrigin(origins = "*")
public class ComplaintController {

    @Autowired
    private ComplaintService complaintService;

    @PostMapping("/create")
    @PreAuthorize("hasRole('CITIZEN')")
    public ResponseEntity<?> createComplaint(@Valid @RequestBody ComplaintCreateDto createDto,
                                           @RequestHeader("X-User-Id") String userId) {
        try {
            Long citizenId = Long.parseLong(userId);
            ComplaintResponseDto complaint = complaintService.createComplaint(createDto, citizenId);
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(Map.of("message", "Complaint created successfully", "complaint", complaint));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('CITIZEN', 'MUNICIPAL_STAFF', 'ADMIN')")
    public ResponseEntity<?> getComplaintById(@PathVariable Long id,
                                            @RequestHeader("X-User-Id") String userId,
                                            @RequestHeader("X-User-Role") String userRole) {
        try {
            ComplaintResponseDto complaint = complaintService.getComplaintById(id);
            
            // Citizens can only view their own complaints
            if ("ROLE_CITIZEN".equals(userRole) && !complaint.getCitizenId().equals(Long.parseLong(userId))) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(Map.of("error", "Access denied"));
            }
            
            return ResponseEntity.ok(complaint);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/all")
    @PreAuthorize("hasAnyRole('MUNICIPAL_STAFF', 'ADMIN')")
    public ResponseEntity<List<ComplaintResponseDto>> getAllComplaints() {
        List<ComplaintResponseDto> complaints = complaintService.getAllComplaints();
        return ResponseEntity.ok(complaints);
    }

    @GetMapping("/my-complaints")
    @PreAuthorize("hasRole('CITIZEN')")
    public ResponseEntity<List<ComplaintResponseDto>> getMyCom‌plaints(@RequestHeader("X-User-Id") String userId) {
        Long citizenId = Long.parseLong(userId);
        List<ComplaintResponseDto> complaints = complaintService.getComplaintsByCitizen(citizenId);
        return ResponseEntity.ok(complaints);
    }

    @GetMapping("/status/{status}")
    @PreAuthorize("hasAnyRole('MUNICIPAL_STAFF', 'ADMIN')")
    public ResponseEntity<List<ComplaintResponseDto>> getComplaintsByStatus(@PathVariable ComplaintStatus status) {
        List<ComplaintResponseDto> complaints = complaintService.getComplaintsByStatus(status);
        return ResponseEntity.ok(complaints);
    }

    @GetMapping("/category/{category}")
    @PreAuthorize("hasAnyRole('MUNICIPAL_STAFF', 'ADMIN')")
    public ResponseEntity<List<ComplaintResponseDto>> getComplaintsByCategory(@PathVariable ComplaintCategory category) {
        List<ComplaintResponseDto> complaints = complaintService.getComplaintsByCategory(category);
        return ResponseEntity.ok(complaints);
    }

    @PutMapping("/{id}/status")
    @PreAuthorize("hasAnyRole('MUNICIPAL_STAFF', 'ADMIN')")
    public ResponseEntity<?> updateComplaintStatus(@PathVariable Long id,
                                                 @RequestParam ComplaintStatus status) {
        try {
            ComplaintResponseDto complaint = complaintService.updateComplaintStatus(id, status);
            return ResponseEntity.ok(Map.of("message", "Status updated successfully", "complaint", complaint));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @PutMapping("/{id}/assign-department")
    @PreAuthorize("hasAnyRole('MUNICIPAL_STAFF', 'ADMIN')")
    public ResponseEntity<?> assignToDepartment(@PathVariable Long id,
                                              @RequestParam String department) {
        try {
            ComplaintResponseDto complaint = complaintService.assignComplaintToDepartment(id, department);
            return ResponseEntity.ok(Map.of("message", "Assigned to department successfully", "complaint", complaint));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @PutMapping("/{id}/assign-staff")
    @PreAuthorize("hasAnyRole('MUNICIPAL_STAFF', 'ADMIN')")
    public ResponseEntity<?> assignToStaff(@PathVariable Long id,
                                         @RequestParam Long staffId) {
        try {
            ComplaintResponseDto complaint = complaintService.assignComplaintToStaff(id, staffId);
            return ResponseEntity.ok(Map.of("message", "Assigned to staff successfully", "complaint", complaint));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/{id}/comments")
    @PreAuthorize("hasAnyRole('CITIZEN', 'MUNICIPAL_STAFF', 'ADMIN')")
    public ResponseEntity<?> addComment(@PathVariable Long id,
                                      @Valid @RequestBody CommentDto commentDto,
                                      @RequestHeader("X-User-Id") String userId,
                                      @RequestHeader("X-User-Role") String userRole) {
        try {
            Long authorId = Long.parseLong(userId);
            String authorName = "User"; // In real implementation, fetch from user service
            String authorRole = userRole.replace("ROLE_", "");
            
            ComplaintResponseDto complaint = complaintService.addComment(id, commentDto, authorId, authorName, authorRole);
            return ResponseEntity.ok(Map.of("message", "Comment added successfully", "complaint", complaint));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> deleteComplaint(@PathVariable Long id) {
        try {
            complaintService.deleteComplaint(id);
            return ResponseEntity.ok(Map.of("message", "Complaint deleted successfully"));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", e.getMessage()));
        }
    }
}