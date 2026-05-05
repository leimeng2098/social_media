package com.example.backend.repository;

import com.example.backend.model.User;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class UserRepository {
    private final JdbcTemplate jdbcTemplate;

    public UserRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public void registerUserViaSP(String username, String phoneNumber, String email, String password) {
        String sql = "CALL sp_register_user(?, ?, ?, ?)";

        jdbcTemplate.update(
                sql,
                username,
                phoneNumber,
                email,
                password
        );
    }

    public User findByPhoneNumberViaSP(String phoneNumber) {
        String sql = "SELECT * FROM fn_login_user(?)";

        List<User> users = jdbcTemplate.query(sql, (rs, rowNum) -> {
            User user = new User();
            user.setId(rs.getLong("id"));
            user.setUsername(rs.getString("username"));
            user.setPassword(rs.getString("password_hash"));
            user.setEmail(rs.getString("email"));
            user.setPhoneNumber(rs.getString("phone_number"));
            user.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
            user.setBiography(rs.getString("biography"));
            user.setAvatarColor(rs.getString("avatar_color"));

            return user;
        }, phoneNumber);

        return users.isEmpty() ? null : users.get(0);
    }

    public void updateUserProfileViaSP(Long id, String username, String biography, String avatarColor) {
        String sql = "CALL sp_update_user_profile(?, ?, ?, ?)";
        jdbcTemplate.update(sql, id, username, biography, avatarColor);
    }
}
