package com.municipal.user.service;

import com.municipal.security.JwtService;
import com.municipal.security.Roles;
import com.municipal.user.domain.User;
import com.municipal.user.repo.UserRepository;
import com.municipal.user.web.dto.AuthDtos;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final BCryptPasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    public UserService(UserRepository userRepository,
                       BCryptPasswordEncoder passwordEncoder,
                       JwtService jwtService,
                       AuthenticationManager authenticationManager) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
        this.authenticationManager = authenticationManager;
    }

    @Transactional
    public User register(AuthDtos.RegisterRequest request) {
        userRepository.findByEmail(request.email).ifPresent(u -> {
            throw new IllegalArgumentException("Email already in use");
        });
        userRepository.findByUsername(request.username).ifPresent(u -> {
            throw new IllegalArgumentException("Username already in use");
        });
        Roles role = request.role;
        User user = new User();
        user.setName(request.name);
        user.setEmail(request.email);
        user.setUsername(request.username);
        user.setPassword(passwordEncoder.encode(request.password));
        user.setRole(role);
        return userRepository.save(user);
    }

    public AuthDtos.AuthResponse login(AuthDtos.LoginRequest request) {
        // try username first, then email
        String principal = userRepository.findByUsername(request.usernameOrEmail)
                .or(() -> userRepository.findByEmail(request.usernameOrEmail))
                .map(User::getUsername)
                .orElse(request.usernameOrEmail);

        try {
            authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(principal, request.password));
        } catch (Exception e) {
            throw new BadCredentialsException("Invalid credentials");
        }

        User user = userRepository.findByUsername(principal)
                .orElseThrow(() -> new BadCredentialsException("Invalid credentials"));
        Map<String, Object> claims = new HashMap<>();
        claims.put("userId", user.getId());
        claims.put("role", user.getRole().name());
        String token = jwtService.generateToken(user.getUsername(), claims);
        return new AuthDtos.AuthResponse(token, user.getId(), user.getUsername(), user.getRole().name());
    }
}