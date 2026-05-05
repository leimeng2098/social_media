-- ==========================================
-- 檔案名稱：04_post_actions.sql
-- 功能：修改與刪除貼文的 Procedure
-- ==========================================

-- 1. 修改貼文 Procedure
CREATE OR REPLACE PROCEDURE sp_update_post(
    p_post_id BIGINT,
    p_user_id BIGINT,
    p_content TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- 透過 AND user_id = p_user_id 確保只有原作者可以修改
    UPDATE posts 
    SET content = p_content 
    WHERE id = p_post_id AND user_id = p_user_id;
END;
$$;

-- 2. 刪除貼文 Procedure
CREATE OR REPLACE PROCEDURE sp_delete_post(
    p_post_id BIGINT,
    p_user_id BIGINT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- 先確認這篇貼文存在，且真的屬於這位使用者
    IF EXISTS (SELECT 1 FROM posts WHERE id = p_post_id AND user_id = p_user_id) THEN
        
        -- 刪除貼文 (因為當初建表有寫 ON DELETE CASCADE，底下的留言會跟著自動消失！)
        DELETE FROM posts WHERE id = p_post_id AND user_id = p_user_id;
        
        -- 同步扣除使用者的發文總數
        UPDATE users SET post_count = post_count - 1 WHERE id = p_user_id;
        
    END IF;
END;
$$;