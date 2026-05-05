package com.example.backend.controller;

import com.example.backend.model.Comment;
import com.example.backend.model.dto.CommentRequest;
import com.example.backend.service.CommentService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/posts")
@CrossOrigin(origins = "http://localhost:5173")
public class CommentController {
    private final CommentService commentService;

    public CommentController(CommentService commentService) {
        this.commentService = commentService;
    }

    @GetMapping("/{postId}/comments")
    public ResponseEntity<List<Comment>> getComments(@PathVariable Long postId) {
        return ResponseEntity.ok(commentService.getCommentsByPostId(postId));
    }

    @PostMapping("/{postId}/comments")
    public ResponseEntity<String> createComment(@PathVariable Long postId, @RequestBody CommentRequest request) {
        commentService.createComment(postId, request);
        return ResponseEntity.ok("Comment posted successfully!");
    }
}
