package com.municipality.userservice.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Controller for handling JSP view requests
 */
@Controller
@RequestMapping("/")
public class WebController {

    /**
     * Home page - redirects to login
     */
    @GetMapping("/")
    public String home() {
        return "redirect:/login";
    }

    /**
     * Login page
     */
    @GetMapping("/login")
    public String login() {
        return "login";
    }

    /**
     * Registration page
     */
    @GetMapping("/register")
    public String register() {
        return "register";
    }

    /**
     * Dashboard page
     */
    @GetMapping("/dashboard")
    public String dashboard() {
        return "dashboard";
    }

    /**
     * Complaints management page
     */
    @GetMapping("/complaints")
    public String complaints() {
        return "complaints";
    }

    /**
     * Departments management page
     */
    @GetMapping("/departments")
    public String departments() {
        return "departments";
    }

    /**
     * User management page
     */
    @GetMapping("/users")
    public String users() {
        return "users";
    }

    /**
     * User profile page
     */
    @GetMapping("/profile")
    public String profile() {
        return "profile";
    }

    /**
     * Error page
     */
    @GetMapping("/error")
    public String error() {
        return "error";
    }
}