-- ==========================================
-- 檔案名稱：01tool_clear_all_data.sql
-- 領域：資料庫維護工具 (DML Tool)
-- 功能：一鍵清空所有業務資料，保留資料表結構與 Functions，並重置 ID
-- ==========================================

-- 執行此行會安全地清空 comments, posts, users 這三張表的所有資料
TRUNCATE TABLE comments, posts, users RESTART IDENTITY CASCADE;
