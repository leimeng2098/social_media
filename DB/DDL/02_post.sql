-- ==========================================
-- 檔案名稱：02_post.sql
-- 領域：貼文 (Post Domain)
-- 功能：貼文資料表結構、發文邏輯與列表查詢
-- ==========================================

-- ------------------------------------------
-- 1. 資料表結構 (Schema)
-- ------------------------------------------
CREATE TABLE IF NOT EXISTS posts (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    image_url VARCHAR(255),
    comment_count INT DEFAULT 0,                  -- 預先建立：留言數量統計
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 建立時間索引，加速動態牆的排序
CREATE INDEX IF NOT EXISTS idx_posts_created_at ON posts(created_at DESC);

-- ------------------------------------------
-- 2. 預存程序與函數 (Procedures & Functions)
-- ------------------------------------------

-- 發文專用的 Procedure (新增貼文 + 更新使用者發文數)
CREATE OR REPLACE PROCEDURE sp_create_post(
    p_user_id BIGINT,
    p_content TEXT,
    p_image_url VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO posts (user_id, content, image_url)
    VALUES (p_user_id, p_content, p_image_url);

    UPDATE users SET post_count = post_count + 1 WHERE id = p_user_id;
END;
$$;

-- 取得首頁貼文列表的 Function (包含完整的統計數據)
CREATE OR REPLACE FUNCTION fn_get_all_posts()
RETURNS TABLE (
    post_id BIGINT,
    user_id BIGINT,
    username VARCHAR,
    content TEXT,
    image_url VARCHAR,
    created_at TIMESTAMP,
    comment_count INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY 
    SELECT p.id, p.user_id, u.username, p.content, p.image_url, p.created_at, p.comment_count
    FROM posts p
    JOIN users u ON p.user_id = u.id
    ORDER BY p.created_at DESC;
END;
$$;

-- 取得單一貼文的 Function (供留言詳細頁面使用)
CREATE OR REPLACE FUNCTION fn_get_post_by_id(p_post_id BIGINT)
RETURNS TABLE (
    post_id BIGINT,
    user_id BIGINT,
    username VARCHAR,
    content TEXT,
    image_url VARCHAR,
    created_at TIMESTAMP,
    comment_count INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY 
    SELECT p.id, p.user_id, u.username, p.content, p.image_url, p.created_at, p.comment_count
    FROM posts p
    JOIN users u ON p.user_id = u.id
    WHERE p.id = p_post_id;
END;
$$;

-- 檢查是否有新貼文的 Function
CREATE OR REPLACE FUNCTION fn_check_new_posts_count(p_last_time TIMESTAMP)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    new_count INTEGER;
BEGIN
    SELECT COUNT(*)::INTEGER INTO new_count FROM posts WHERE created_at > p_last_time;
    RETURN new_count;
END;
$$;