-- ==========================================
-- 檔案名稱：03_comment.sql
-- 領域：留言 (Comment Domain)
-- 功能：留言資料表結構、回覆邏輯與列表查詢
-- ==========================================

-- ------------------------------------------
-- 1. 資料表結構 (Schema)
-- ------------------------------------------
CREATE TABLE IF NOT EXISTS comments (
    id BIGSERIAL PRIMARY KEY,
    post_id BIGINT NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 建立索引：加速查詢某篇貼文底下的所有留言
CREATE INDEX IF NOT EXISTS idx_comments_post_id ON comments(post_id);

-- ------------------------------------------
-- 2. 預存程序與函數 (Procedures & Functions)
-- ------------------------------------------

-- 建立留言的 Procedure (新增留言 + 更新貼文的留言數)
CREATE OR REPLACE PROCEDURE sp_create_comment(
    p_post_id BIGINT,
    p_user_id BIGINT,
    p_content TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO comments (post_id, user_id, content)
    VALUES (p_post_id, p_user_id, p_content);

    UPDATE posts SET comment_count = comment_count + 1 WHERE id = p_post_id;
END;
$$;

-- 取得特定貼文的所有留言 Function
CREATE OR REPLACE FUNCTION fn_get_comments_by_post(p_post_id BIGINT)
RETURNS TABLE (
    comment_id BIGINT,
    post_id BIGINT,
    user_id BIGINT,
    username VARCHAR,
    content TEXT,
    created_at TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY 
    SELECT c.id, c.post_id, c.user_id, u.username, c.content, c.created_at
    FROM comments c
    JOIN users u ON c.user_id = u.id
    WHERE c.post_id = p_post_id
    ORDER BY c.created_at ASC; 
END;
$$;