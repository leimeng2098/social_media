package com.example.backend.service;

import com.example.backend.model.Comment;
import com.example.backend.model.dto.CommentRequest;
import com.example.backend.repository.CommentRepository;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class CommentService {
    private final CommentRepository commentRepository;

    public CommentService(CommentRepository commentRepository) {
        this.commentRepository = commentRepository;
    }

    public void createComment(Long postId, CommentRequest request) {
        if (request.getContent() == null || request.getContent().trim().isEmpty()) {
            throw new IllegalArgumentException("Comment content cannot be empty!");
        }
        commentRepository.createCommentViaSP(postId, request.getUserId(), request.getContent());
    }

    public List<Comment> getCommentsByPostId(Long postId) {
        return commentRepository.getCommentsByPostIdViaSP(postId);
    }
}