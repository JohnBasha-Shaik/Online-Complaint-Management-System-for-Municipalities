package com.municipal.user.web.dto;

import com.municipal.security.Roles;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public class AuthDtos {

    public static class RegisterRequest {
        @NotBlank
        @Size(min = 2, max = 100)
        public String name;

        @NotBlank
        @Email
        public String email;

        @NotBlank
        @Size(min = 4, max = 50)
        @Pattern(regexp = "^[a-zA-Z0-9_.-]+$", message = "Username contains invalid characters")
        public String username;

        @NotBlank
        @Size(min = 8, max = 100)
        @Pattern(regexp = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).+$", message = "Password must contain upper, lower, and digit")
        public String password;

        @NotNull
        public Roles role;
    }

    public static class LoginRequest {
        @NotBlank
        public String usernameOrEmail;

        @NotBlank
        public String password;
    }

    public static class AuthResponse {
        public String token;
        public Long userId;
        public String username;
        public String role;

        public AuthResponse(String token, Long userId, String username, String role) {
            this.token = token;
            this.userId = userId;
            this.username = username;
            this.role = role;
        }
    }
}