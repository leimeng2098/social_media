-- ==========================================
-- 檔案名稱：06_user_profile.sql
-- 領域：使用者 (User Domain) - 擴充功能
-- 功能：新增頭像顏色欄位、更新個人資料 Procedure
-- ==========================================

-- 1. 新增頭像顏色欄位 (如果不存在的話)
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS avatar_color VARCHAR(20);
-- 2. 確保顏色欄位正確
ALTER TABLE users 
ALTER COLUMN avatar_color SET DEFAULT 'bg-[#79B4EC]';

-- 3. 建立更新個人資料的 Procedure (包含暱稱、介紹與顏色)
CREATE OR REPLACE PROCEDURE sp_update_user_profile(
    p_user_id BIGINT,
    p_username VARCHAR,
    p_biography TEXT,
    p_avatar_color VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE users 
    SET username = p_username, 
        biography = p_biography,
        avatar_color = p_avatar_color
    WHERE id = p_user_id;
END;
$$;