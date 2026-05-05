package com.example.backend.service;

import com.example.backend.model.Post;
import com.example.backend.model.dto.PostRequest;
import com.example.backend.repository.PostRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class PostService {
    private final PostRepository postRepository;

    public PostService(PostRepository postRepository) {
        this.postRepository = postRepository;
    }

    public void createPost(PostRequest request) {
        if (request.getContent() == null || request.getContent().trim().isEmpty()) {
            throw new IllegalArgumentException("Post content cannot be empty!");
        }
        postRepository.createPostViaSP(request.getUserId(), request.getContent(), request.getImageUrl());
    }

    public List<Post> getAllPosts() {
        return postRepository.getAllPostsViaSP();
    }

    public Integer getNewPostsCount(LocalDateTime lastCheckTime) {
        if (lastCheckTime == null) return 0;
        return postRepository.checkNewPostsCountViaSP(lastCheckTime);
    }

    public Post getPostById(Long id) {
        Post post = postRepository.getPostByIdViaSP(id);
        if (post == null) {
            throw new IllegalArgumentException("Post not found!");
        }
        return post;
    }

    public void updatePost(Long postId, Long userId, String content) {
        if (content == null || content.trim().isEmpty()) {
            throw new IllegalArgumentException("Post content cannot be empty!");
        }
        postRepository.updatePostViaSP(postId, userId, content);
    }

    public void deletePost(Long postId, Long userId) {
        postRepository.deletePostViaSP(postId, userId);
    }
}
