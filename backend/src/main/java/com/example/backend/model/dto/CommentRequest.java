package com.example.backend.model.dto;

public class CommentRequest {
    private Long userId;
    private String content;

    // ---  Getter & Setter ---
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
}
