package com.municipality.notification.controller;

import com.municipality.notification.service.EmailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/")
@CrossOrigin(origins = "*")
public class NotificationController {

    @Autowired
    private EmailService emailService;

    @PostMapping("/email/status-update")
    public ResponseEntity<?> sendStatusUpdate(@RequestBody Map<String, String> request) {
        try {
            emailService.sendComplaintStatusUpdate(
                request.get("email"),
                request.get("complaintId"),
                request.get("status")
            );
            return ResponseEntity.ok(Map.of("message", "Email sent successfully"));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "Failed to send email: " + e.getMessage()));
        }
    }

    @PostMapping("/email/assignment")
    public ResponseEntity<?> sendAssignmentNotification(@RequestBody Map<String, String> request) {
        try {
            emailService.sendComplaintAssignment(
                request.get("email"),
                request.get("complaintId"),
                request.get("department")
            );
            return ResponseEntity.ok(Map.of("message", "Email sent successfully"));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "Failed to send email: " + e.getMessage()));
        }
    }
}