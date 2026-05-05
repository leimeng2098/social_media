# 社交媒體全端平台 (Full-Stack Social Media Platform)

這是一個基於 Vue 3 與 Spring Boot 開發的全端社交媒體應用程式，提供完整的使用者註冊、登入、發文與留言功能。後端資料庫高度依賴 PostgreSQL 的預存程序 (Stored Procedure) 來封裝商業邏輯與確保交易安全 (Transaction)。

## 🚀 核心技術棧 (Tech Stack)
* **前端 (Frontend)**: Vue.js 3 (Composition API), Vite, Tailwind CSS, Vue Router, Axios
* **後端 (Backend)**: Java 17, Spring Boot, Spring Data JDBC
* **資料庫 (Database)**: PostgreSQL 15+

## ✨ 系統亮點 (Key Features)
1. **完整 CRUD 週期**: 支援貼文的發佈、修改、刪除與留言功能。
2. **資料庫層級封裝**: 透過 `Procedure` 處理多表異動 (如新增貼文時同步更新使用者的發文總數)，確保 Transaction 資料一致性。
3. **資安防護 (Security)**:
   * **SQL Injection 防禦**: 後端採用 Parameterized Queries (參數化查詢)。
   * **XSS 防禦**: 實作全域 `XssFilter` 進行輸入消毒，搭配 Vue 的自動跳脫機制實現雙層防護。
   * **密碼安全**: 使用加鹽雜湊 (Hash) 儲存使用者密碼。

## 📁 資料夾結構 (Project Structure)
* `/frontend`: Vue 3 前端專案程式碼
* `/backend`: Spring Boot 後端專案程式碼
* `/DB`: 資料庫初始化與 DDL/DML SQL 腳本 (包含 Schema 與 Procedures)

## 🛠️ 本地端執行指南 (Setup Instructions)

### 1. 資料庫設定
1. 安裝並啟動 PostgreSQL。
2. 執行 `/DB` 目錄下的 `00_init_database.sql` 建立資料庫。
3. 切換至建立好的資料庫，依序執行 `01_user.sql`, `02_post.sql`, `03_comment.sql`。
4. 修改後端 `/backend/src/main/resources/application.properties` 中的資料庫連線帳號密碼。

### 2. 啟動後端 (Spring Boot)
進入 `backend` 目錄，使用 Gradle 啟動：
\`\`\`bash
cd backend
./gradlew bootRun
\`\`\`
服務將運行於 `http://localhost:8080`。

### 3. 啟動前端 (Vue.js)
進入 `frontend` 目錄，安裝依賴並啟動開發伺服器：
\`\`\`bash
cd frontend
npm install
npm run dev
\`\`\`
網頁將運行於 `http://localhost:5173`。