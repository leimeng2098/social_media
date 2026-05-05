package com.example.backend.service;

import com.example.backend.model.User;
import com.example.backend.model.dto.UserRequest;
import com.example.backend.repository.UserRepository;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    // 註冊邏輯
    public void register(UserRequest request) {
        if (request.getUsername() == null || request.getPassword() == null || request.getPhoneNumber() == null) {
            throw new IllegalArgumentException("Username, password, and phone number are required!");
        }

        String hashedPassword = request.getPassword();

        userRepository.registerUserViaSP(
                request.getUsername(),
                request.getPhoneNumber(),
                request.getEmail(),
                hashedPassword
        );
    }

    public User login(UserRequest request) {
        if (request.getPhoneNumber() == null || request.getPassword() == null) {
            throw new IllegalArgumentException("Phone number and password are required!");
        }

        User user = userRepository.findByPhoneNumberViaSP(request.getPhoneNumber());

        if (user == null || !user.getPassword().equals(request.getPassword())) {
            throw new IllegalArgumentException("Incorrect phone number or password!");
        }

        return user;
    }
}
