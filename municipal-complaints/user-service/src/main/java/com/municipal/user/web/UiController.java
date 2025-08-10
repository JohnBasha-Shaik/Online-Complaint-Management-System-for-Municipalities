package com.municipal.user.web;

import com.municipal.user.service.UserService;
import com.municipal.user.web.dto.AuthDtos;
import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class UiController {

    private final UserService userService;

    public UiController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping({"/", "/ui/login"})
    public String loginPage(Model model) {
        model.addAttribute("loginRequest", new AuthDtos.LoginRequest());
        return "login";
    }

    @GetMapping("/ui/register")
    public String registerPage(Model model) {
        model.addAttribute("registerRequest", new AuthDtos.RegisterRequest());
        return "register";
    }

    @PostMapping("/api/users/auth/register-ui")
    public String registerSubmit(@Valid @ModelAttribute("registerRequest") AuthDtos.RegisterRequest req,
                                 BindingResult result, Model model) {
        if (result.hasErrors()) {
            return "register";
        }
        try {
            userService.register(req);
            return "redirect:/ui/login";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "register";
        }
    }

    @PostMapping("/api/users/auth/login-ui")
    public String loginSubmit(@Valid @ModelAttribute("loginRequest") AuthDtos.LoginRequest req,
                              BindingResult result, Model model) {
        if (result.hasErrors()) {
            return "login";
        }
        try {
            var resp = userService.login(req);
            // In a real UI, store JWT in cookie/storage; here we redirect to dashboards based on role
            return switch (resp.role) {
                case "ADMIN" -> "redirect:/api/users/dashboard/admin";
                case "STAFF" -> "redirect:/api/users/dashboard/staff";
                default -> "redirect:/api/users/dashboard/citizen";
            };
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "login";
        }
    }
}