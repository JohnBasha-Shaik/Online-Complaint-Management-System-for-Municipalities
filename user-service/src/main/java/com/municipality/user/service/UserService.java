package com.municipality.user.service;

import com.municipality.user.dto.UserLoginDto;
import com.municipality.user.dto.UserRegistrationDto;
import com.municipality.user.dto.UserResponseDto;
import com.municipality.user.entity.Role;

import java.util.List;

public interface UserService {
    UserResponseDto registerUser(UserRegistrationDto registrationDto);
    String loginUser(UserLoginDto loginDto);
    UserResponseDto getUserById(Long id);
    UserResponseDto getUserByUsername(String username);
    List<UserResponseDto> getAllUsers();
    List<UserResponseDto> getUsersByRole(Role role);
    UserResponseDto updateUser(Long id, UserRegistrationDto updateDto);
    void deleteUser(Long id);
    void deactivateUser(Long id);
    void activateUser(Long id);
}