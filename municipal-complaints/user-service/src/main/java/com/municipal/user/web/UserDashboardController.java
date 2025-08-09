package com.municipal.user.web;

import com.municipal.security.Roles;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/users/dashboard")
public class UserDashboardController {

    @GetMapping("/citizen")
    @PreAuthorize("hasRole('CITIZEN')")
    public String citizenDashboard() {
        return "Citizen dashboard";
    }

    @GetMapping("/staff")
    @PreAuthorize("hasRole('STAFF')")
    public String staffDashboard() {
        return "Staff dashboard";
    }

    @GetMapping("/admin")
    @PreAuthorize("hasRole('ADMIN')")
    public String adminDashboard() {
        return "Admin dashboard";
    }
}