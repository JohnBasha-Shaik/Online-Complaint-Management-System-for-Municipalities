package com.municipality.user.controller;

import com.municipality.user.dto.AuthResponse;
import com.municipality.user.dto.LoginRequest;
import com.municipality.user.dto.UserRegistrationRequest;
import com.municipality.user.entity.User;
import com.municipality.user.entity.UserRole;
import com.municipality.user.service.UserService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*")
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> registerUser(@Valid @RequestBody UserRegistrationRequest request) {
        try {
            AuthResponse response = userService.registerUser(request);
            if (response.getToken() != null) {
                return ResponseEntity.ok(response);
            } else {
                return ResponseEntity.badRequest().body(response);
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new AuthResponse(null, null, null, null, null, "Registration failed: " + e.getMessage()));
        }
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> loginUser(@Valid @RequestBody LoginRequest request) {
        try {
            AuthResponse response = userService.loginUser(request);
            if (response.getToken() != null) {
                return ResponseEntity.ok(response);
            } else {
                return ResponseEntity.badRequest().body(response);
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new AuthResponse(null, null, null, null, null, "Login failed: " + e.getMessage()));
        }
    }

    @GetMapping("/profile/{username}")
    @PreAuthorize("hasRole('ADMIN') or authentication.name == #username")
    public ResponseEntity<User> getUserProfile(@PathVariable String username) {
        Optional<User> user = userService.findByUsername(username);
        if (user.isPresent()) {
            // Remove password from response
            User userResponse = user.get();
            userResponse.setPassword(null);
            return ResponseEntity.ok(userResponse);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/all")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<User>> getAllUsers() {
        List<User> users = userService.findAllActiveUsers();
        // Remove passwords from response
        users.forEach(user -> user.setPassword(null));
        return ResponseEntity.ok(users);
    }

    @GetMapping("/role/{role}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('MUNICIPAL_STAFF')")
    public ResponseEntity<List<User>> getUsersByRole(@PathVariable UserRole role) {
        List<User> users = userService.findUsersByRole(role);
        // Remove passwords from response
        users.forEach(user -> user.setPassword(null));
        return ResponseEntity.ok(users);
    }

    @GetMapping("/staff")
    @PreAuthorize("hasRole('ADMIN') or hasRole('MUNICIPAL_STAFF')")
    public ResponseEntity<List<User>> getMunicipalStaff() {
        List<User> staff = userService.getMunicipalStaff();
        // Remove passwords from response
        staff.forEach(user -> user.setPassword(null));
        return ResponseEntity.ok(staff);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or (authentication.name == @userService.findById(#id).orElse(new com.municipality.user.entity.User()).username)")
    public ResponseEntity<User> updateUser(@PathVariable Long id, @Valid @RequestBody User user) {
        User updatedUser = userService.updateUser(id, user);
        if (updatedUser != null) {
            updatedUser.setPassword(null); // Remove password from response
            return ResponseEntity.ok(updatedUser);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @PutMapping("/{id}/deactivate")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<String> deactivateUser(@PathVariable Long id) {
        boolean deactivated = userService.deactivateUser(id);
        if (deactivated) {
            return ResponseEntity.ok("User deactivated successfully");
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @PutMapping("/{id}/activate")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<String> activateUser(@PathVariable Long id) {
        boolean activated = userService.activateUser(id);
        if (activated) {
            return ResponseEntity.ok("User activated successfully");
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/dashboard")
    @PreAuthorize("hasRole('CITIZEN') or hasRole('MUNICIPAL_STAFF') or hasRole('ADMIN')")
    public ResponseEntity<String> getDashboard() {
        return ResponseEntity.ok("Welcome to your dashboard! Access granted based on your role.");
    }
}