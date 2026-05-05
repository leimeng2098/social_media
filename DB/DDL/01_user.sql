-- ==========================================
-- 檔案名稱：01_user.sql
-- 領域：使用者 (User Domain)
-- 功能：使用者資料表結構、註冊與登入邏輯
-- ==========================================

-- ------------------------------------------
-- 1. 資料表結構 (Schema)
-- ------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(255),
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    cover_image VARCHAR(255),
    biography TEXT DEFAULT 'Hello~~',
    post_count INT DEFAULT 0,                     -- 預先建立：發文數量統計
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 建立電話號碼索引，加速登入查詢
CREATE INDEX IF NOT EXISTS idx_users_phone ON users(phone_number);

-- ------------------------------------------
-- 2. 預存程序與函數 (Procedures & Functions)
-- ------------------------------------------

-- 註冊用的 Stored Procedure
CREATE OR REPLACE PROCEDURE sp_register_user(
    p_username VARCHAR,
    p_phone_number VARCHAR, 
    p_email VARCHAR,        
    p_password_hash VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO users (username, phone_number, email, password_hash)
    VALUES (p_username, p_phone_number, p_email, p_password_hash);
END;
$$;

-- 登入查詢用的 Function (透過電話號碼查詢)
CREATE OR REPLACE FUNCTION fn_login_user(p_phone_number VARCHAR)
RETURNS SETOF users
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY 
    SELECT * FROM users 
    WHERE phone_number = p_phone_number;
END;
$$;