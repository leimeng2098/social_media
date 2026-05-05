package com.example.backend.repository;

import com.example.backend.model.Comment;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public class CommentRepository {
    private final JdbcTemplate jdbcTemplate;

    public CommentRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public void createCommentViaSP(Long postId, Long userId, String content) {
        String sql = "CALL sp_create_comment(?, ?, ?)";
        jdbcTemplate.update(sql, postId, userId, content);
    }

    public List<Comment> getCommentsByPostIdViaSP(Long postId) {
        String sql = "SELECT * FROM fn_get_comments_by_post(?)";
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            Comment comment = new Comment();
            comment.setId(rs.getLong("id"));
            comment.setPostId(rs.getLong("post_id"));
            comment.setUserId(rs.getLong("user_id"));
            comment.setUsername(rs.getString("username"));
            comment.setContent(rs.getString("content"));
            comment.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
            comment.setAvatarColor(rs.getString("avatar_color"));
            return comment;
        }, postId);
    }
}