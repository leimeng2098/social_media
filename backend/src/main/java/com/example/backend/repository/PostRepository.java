package com.example.backend.repository;

import com.example.backend.model.Post;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public class PostRepository {
    private final JdbcTemplate jdbcTemplate;

    public PostRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public void createPostViaSP(Long userId, String content, String imageUrl) {
        String sql = "CALL sp_create_post(?, ?, ?)";
        jdbcTemplate.update(sql, userId, content, imageUrl);
    }

    public List<Post> getAllPostsViaSP() {
        String sql = "SELECT * FROM fn_get_all_posts()";
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            Post post = new Post();
            post.setId(rs.getLong("post_id"));
            post.setUserId(rs.getLong("user_id"));
            post.setUsername(rs.getString("username"));
            post.setContent(rs.getString("content"));
            post.setImageUrl(rs.getString("image_url"));
            post.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());

            post.setCommentCount(rs.getInt("comment_count"));

            return post;
        });
    }

    public Integer checkNewPostsCountViaSP(LocalDateTime lastCheckTime) {
        String sql = "SELECT fn_check_new_posts_count(?)";
        return jdbcTemplate.queryForObject(sql, Integer.class, lastCheckTime);
    }

    public Post getPostByIdViaSP(Long id) {
        String sql = "SELECT * FROM fn_get_post_by_id(?)";
        List<Post> posts = jdbcTemplate.query(sql, (rs, rowNum) -> {
            Post post = new Post();
            post.setId(rs.getLong("post_id"));
            post.setUserId(rs.getLong("user_id"));
            post.setUsername(rs.getString("username"));
            post.setContent(rs.getString("content"));
            post.setImageUrl(rs.getString("image_url"));
            post.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
            post.setCommentCount(rs.getInt("comment_count"));
            return post;
        }, id);

        return posts.isEmpty() ? null : posts.get(0);
    }

    // 更新貼文
    public void updatePostViaSP(Long postId, Long userId, String content) {
        String sql = "CALL sp_update_post(?, ?, ?)";
        jdbcTemplate.update(sql, postId, userId, content);
    }

    // 刪除貼文
    public void deletePostViaSP(Long postId, Long userId) {
        String sql = "CALL sp_delete_post(?, ?)";
        jdbcTemplate.update(sql, postId, userId);
    }
}
