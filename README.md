# 社群媒體系統

本專案為包含Web Server、Application Server、關聯式資料庫的三層式架構。

---

## 壹、Web Server

前端負責畫面渲染與狀態管理，採前後端分離架構，所有資料皆透過 Axios 向後端 API 請求。

* **環境依賴**：Node.js, npm
* **核心技術棧**：Vue 3 (Composition API), Vite, Tailwind CSS, Vue Router, Axios
* **核心架構**：
  * **狀態管理**：全面採用響應式變數 (`ref`, `reactive`) 進行狀態追蹤與畫面連動。
  * **路由控制**：透過 Vue Router 實現 SPA (Single Page Application)，並支援動態參數路由（如貼文詳細頁 `/post/:id`）。
  * **API 模組化**：實作 Axios 基礎配置 (位於 `/src/api/axios.js`)，統一處理後端 API 的 Base URL 與跨域 (CORS) 請求。
  * **XSS 防禦**：利用 Vue 原生模板綁定機制（`{{ }}`）自動跳脫特殊字元，全專案嚴禁使用 `v-html`，形成前端防護網。
* **啟動指令**：
  進入 `/frontend` 目錄進行套件安裝與啟動：
  ```bash
  cd frontend
  
  # 首次運行需安裝環境依賴套件
  npm install
  
  # 啟動本地端開發伺服器
  npm run dev
  ```
服務啟動後，請於瀏覽器開啟 http://localhost:5173 進行瀏覽與測試。

---

## 貳、Application Server

後端主要作為 API Gateway，負責接收前端請求、進行參數校驗與資安過濾，並橋接資料庫的預存程序。

* **環境依賴**：Java 17, Spring Boot, Gradle
* **核心架構**：
  * **RESTful API**：遵循標準 HTTP 狀態碼與動詞 (GET/POST/PUT/DELETE)。
  * **分層設計**：Controller (路由) -> Service (業務檢核) -> Repository (資料存取)。
  * **資料庫溝通**：使用 Spring Data JDBC (`JdbcTemplate`) 呼叫 Stored Procedure，並嚴格採用**參數化查詢 (Parameterized Queries)** 阻絕 SQL Injection。
  * **資安實作**：配置全域 `XssFilter` 攔截惡意腳本輸入；使用 `GlobalExceptionHandler` 統一攔截並格式化錯誤回應。
* **啟動指令**：
  進入 `/backend` 目錄前，請先至 `src/main/resources/application.properties` 確認資料庫的連線帳密是否正確。
  ```bash
  cd backend
  
  # 使用 Gradle Wrapper 啟動應用程式 (預設 Port: 8080)
  ./gradlew bootRun

---

## 參、關聯式資料庫

本專案將核心業務邏輯（如：發文與計數器的連動）下放至資料庫層，以確保 Transaction 的絕對一致性並減輕應用層負擔。

* **環境依賴**：PostgreSQL 17.9
* **核心架構**：
  * 使用關聯式設計，涵蓋 `users`、`posts`、`comments` 三大核心 Domain。
  * 採用 **Stored Procedure** 封裝寫入邏輯（如 `sp_create_post`），並透過 **Function** 處理多表關聯查詢。
* **部署與初始化指令**：
  請確保已啟動 PostgreSQL 服務，並透過 DBeaver 或 psql 工具依序執行 `/DB` 目錄下的腳本：
  1. 執行 `00_init_database.sql` 建立 `social_media` 資料庫。
  2. 切換連線至 `social_media` 資料庫。
  3. 依序執行 `01_user.sql`、`02_post.sql`、`03_comment.sql`、`04_post_actions.sql`、`05_user_profile.sql`、`06_mock_data.sql` 完成 Table、Index 與 Procedures 的建置。
