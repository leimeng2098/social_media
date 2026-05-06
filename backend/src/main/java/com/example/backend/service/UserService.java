package com.example.backend.service;

import com.example.backend.model.User;
import com.example.backend.model.dto.UserRequest;
import com.example.backend.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.mindrot.jbcrypt.BCrypt;

@Service
public class UserService {
    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public void register(UserRequest request) {
        if (request.getUsername() == null || request.getPassword() == null || request.getPhoneNumber() == null) {
            throw new IllegalArgumentException("Username, password, and phone number are required!");
        }

        String hashedPassword = BCrypt.hashpw(request.getPassword(), BCrypt.gensalt());

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

        if (user == null || !BCrypt.checkpw(request.getPassword(), user.getPassword())) {
            throw new IllegalArgumentException("Incorrect phone number or password!");
        }

        return user;
    }

    public void updateProfile(Long id, String username, String biography, String avatarColor) {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Nickname cannot be empty!");
        }
        userRepository.updateUserProfileViaSP(id, username, biography, avatarColor);
    }
}
