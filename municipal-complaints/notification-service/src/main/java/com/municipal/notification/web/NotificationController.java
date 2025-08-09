package com.municipal.notification.web;

import com.municipal.notification.service.NotificationService;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/notifications")
public class NotificationController {

    private final NotificationService notificationService;

    public NotificationController(NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    @PostMapping("/email")
    @PreAuthorize("hasAnyRole('STAFF','ADMIN')")
    public void email(@RequestParam @Email String to, @RequestParam String subject, @RequestParam @NotBlank String body) {
        notificationService.sendEmail(to, subject, body);
    }

    @PostMapping("/sms")
    @PreAuthorize("hasAnyRole('STAFF','ADMIN')")
    public void sms(@RequestParam @NotBlank String phone, @RequestParam @NotBlank String message) {
        notificationService.sendSms(phone, message);
    }
}