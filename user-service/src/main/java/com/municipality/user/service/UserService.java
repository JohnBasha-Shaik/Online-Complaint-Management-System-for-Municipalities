package com.municipality.user.service;

import com.municipality.user.dto.AuthResponse;
import com.municipality.user.dto.LoginRequest;
import com.municipality.user.dto.UserRegistrationRequest;
import com.municipality.user.entity.User;
import com.municipality.user.entity.UserRole;
import com.municipality.user.repository.UserRepository;
import com.municipality.user.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtil jwtUtil;

    public AuthResponse registerUser(UserRegistrationRequest request) {
        // Check if username already exists
        if (userRepository.existsByUsername(request.getUsername())) {
            return new AuthResponse(null, null, null, null, null, "Username already exists");
        }

        // Check if email already exists
        if (userRepository.existsByEmail(request.getEmail())) {
            return new AuthResponse(null, null, null, null, null, "Email already exists");
        }

        // Create new user
        User user = new User();
        user.setName(request.getName());
        user.setEmail(request.getEmail());
        user.setUsername(request.getUsername());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setRole(request.getRole());

        User savedUser = userRepository.save(user);

        // Generate JWT token
        String token = jwtUtil.generateToken(savedUser.getUsername(), savedUser.getRole().name());

        return new AuthResponse(
                token,
                savedUser.getUsername(),
                savedUser.getName(),
                savedUser.getEmail(),
                savedUser.getRole(),
                "User registered successfully"
        );
    }

    public AuthResponse loginUser(LoginRequest request) {
        Optional<User> userOptional = userRepository.findActiveUserByUsername(request.getUsername());

        if (userOptional.isEmpty()) {
            return new AuthResponse(null, null, null, null, null, "Invalid username or password");
        }

        User user = userOptional.get();

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            return new AuthResponse(null, null, null, null, null, "Invalid username or password");
        }

        // Generate JWT token
        String token = jwtUtil.generateToken(user.getUsername(), user.getRole().name());

        return new AuthResponse(
                token,
                user.getUsername(),
                user.getName(),
                user.getEmail(),
                user.getRole(),
                "Login successful"
        );
    }

    public Optional<User> findByUsername(String username) {
        return userRepository.findActiveUserByUsername(username);
    }

    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }

    public List<User> findAllActiveUsers() {
        return userRepository.findByIsActiveTrue();
    }

    public List<User> findUsersByRole(UserRole role) {
        return userRepository.findActiveUsersByRole(role);
    }

    public User updateUser(Long id, User updatedUser) {
        Optional<User> userOptional = userRepository.findById(id);
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            user.setName(updatedUser.getName());
            user.setEmail(updatedUser.getEmail());
            if (updatedUser.getPassword() != null && !updatedUser.getPassword().isEmpty()) {
                user.setPassword(passwordEncoder.encode(updatedUser.getPassword()));
            }
            return userRepository.save(user);
        }
        return null;
    }

    public boolean deactivateUser(Long id) {
        Optional<User> userOptional = userRepository.findById(id);
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            user.setIsActive(false);
            userRepository.save(user);
            return true;
        }
        return false;
    }

    public boolean activateUser(Long id) {
        Optional<User> userOptional = userRepository.findById(id);
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            user.setIsActive(true);
            userRepository.save(user);
            return true;
        }
        return false;
    }

    public List<User> getMunicipalStaff() {
        return userRepository.findActiveUsersByRole(UserRole.MUNICIPAL_STAFF);
    }
}