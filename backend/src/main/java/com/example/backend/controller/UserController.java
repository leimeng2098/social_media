package com.example.backend.controller;

import com.example.backend.common.ApiResponse;
import com.example.backend.model.User;
import com.example.backend.model.dto.UserRequest;
import com.example.backend.service.UserService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "http://localhost:5173")
public class UserController {
    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/register")
    public ApiResponse<String> register(@RequestBody UserRequest request) {
        userService.register(request);
        return ApiResponse.success("Registration successful!", null);
    }

    @PostMapping("/login")
    public ApiResponse<User> login(@RequestBody UserRequest request) {
        User loggedInUser = userService.login(request);
        loggedInUser.setPassword(null);
        return ApiResponse.success("Login successful!", loggedInUser);
    }

    @PutMapping("/{id}")
    public ApiResponse<String> updateProfile(@PathVariable Long id, @RequestBody UserRequest request) {
        userService.updateProfile(id, request.getUsername(), request.getBiography(), request.getAvatarColor());
        return ApiResponse.success("個人資料更新成功！", null);
    }
}
