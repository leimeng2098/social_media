-- ==========================================
-- 檔案名稱：00_init_database.sql
-- 功能：建立專案專屬資料庫
-- 注意：執行此腳本時，請確保你是連線在預設的 postgres 系統資料庫上
-- ==========================================

-- 建立社群媒體專案資料庫 (並設定編碼為 UTF8 以支援中文)
CREATE DATABASE social_media
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;