-- ==========================================
-- 檔案名稱：05_mock_data.sql
-- 領域：資料操作 (DML) - 種子資料 (Seed Data)
-- 功能：插入 10位使用者、30篇貼文、以及隨機留言
-- 注意：執行此腳本會【清空】現有資料表，並重新從 ID 1 開始建立假資料！
-- ==========================================

-- 1. 清空所有資料表，並重置 ID 遞增序列
TRUNCATE TABLE comments, posts, users RESTART IDENTITY CASCADE;

-- 2. 新增 10 位使用者 (密碼先統一代入一個簡單的雜湊值示意)
INSERT INTO users (username, phone_number, email, password_hash, biography) VALUES
('全端菜鳥', '0911000111', 'dev@test.com', 'hashed_pwd_123', '持續學習 Vue 與 Spring Boot 中！'),
('吃貨小美', '0922000222', 'foodie@test.com', 'hashed_pwd_123', '用鏡頭記錄各地的美食🍜'),
('貓奴阿李', '0933000333', 'catlover@test.com', 'hashed_pwd_123', '主子每天都在鍵盤上睡覺。'),
('電影狂人', '0944000444', 'movie@test.com', 'hashed_pwd_123', '無雷影評，週末都在電影院度過。'),
('拿鐵去冰', '0955000555', 'coffee@test.com', 'hashed_pwd_123', '咖啡因是我的生命之水☕'),
('說走就走', '0966000666', 'travel@test.com', 'hashed_pwd_123', '喜歡拍風景，熱愛自由行。'),
('健身房打卡', '0977000777', 'gym@test.com', 'hashed_pwd_123', '深蹲救台灣！💪'),
('愛看書的魚', '0988000888', 'book@test.com', 'hashed_pwd_123', '文字有治癒人心的力量。'),
('耳機不離身', '0999000999', 'music@test.com', 'hashed_pwd_123', '各種類型的音樂都聽。'),
('夜貓子', '0900000000', 'night@test.com', 'hashed_pwd_123', '越晚越有靈感。');

-- 3. 新增 30 篇貼文 (使用 INTERVAL 模擬不同時間點發佈)
INSERT INTO posts (user_id, content, created_at) VALUES
(1, '終於把前後端連線的 Bug 解掉了！看著畫面上出現資料，成就感滿滿啊😭', NOW() - INTERVAL '15 days'),
(2, '發現巷口新開了一家拉麵店，湯頭超級濃郁，叉燒入口即化，大推！', NOW() - INTERVAL '14 days'),
(3, '今天剛買的新鍵盤，不到五分鐘就被家裡的貓佔領了...誰來救救我？', NOW() - INTERVAL '14 days'),
(4, '剛看完最新上映的科幻大片，特效真的很棒，但劇情結尾有點收不回來，給個 7.5 分。', NOW() - INTERVAL '13 days'),
(5, '早晨就是要來一杯手沖咖啡，今天嘗試了淺焙的衣索比亞豆，果酸味很驚豔。', NOW() - INTERVAL '13 days'),
(6, '週末去爬了合歡山，雖然冷到發抖，但日出出來的那一刻真的太美了！', NOW() - INTERVAL '12 days'),
(7, '今天的腿部訓練徹底炸裂，明天應該下不了樓梯了😵', NOW() - INTERVAL '11 days'),
(8, '最近看完《原子習慣》，覺得收穫很多，決定每天進步 1%！', NOW() - INTERVAL '11 days'),
(9, '有沒有推薦的獨立樂團？最近歌單聽膩了，求推薦！', NOW() - INTERVAL '10 days'),
(10, '半夜肚子餓泡了一碗泡麵，這絕對是世界上最邪惡但也最療癒的食物。', NOW() - INTERVAL '10 days'),
(1, 'Vue 3 的 Composition API 真的比 Vue 2 好用太多了，邏輯清楚很多！', NOW() - INTERVAL '9 days'),
(2, '今天挑戰自己煮義大利麵，結果麵條煮太軟，看來還是乖乖叫外送好了😂', NOW() - INTERVAL '9 days'),
(3, '給大家看看我家主子今天的新睡姿，根本是一條海參。', NOW() - INTERVAL '8 days'),
(4, '重溫了經典神作《全面啟動》，每次看都有不同的細節發現，太神了。', NOW() - INTERVAL '8 days'),
(5, '連鎖咖啡店出新品了！下午立刻翹班...不是，是請假去買來喝喝看。', NOW() - INTERVAL '7 days'),
(6, '訂好下個月的機票了！有沒有人去過北海道，求推薦私房景點！', NOW() - INTERVAL '7 days'),
(7, '體脂率終於降到 15% 以下了，幾個月來的飲食控制總算沒有白費🎉', NOW() - INTERVAL '6 days'),
(8, '下雨天最適合待在咖啡廳看一整個下午的書，配上一塊磅蛋糕。', NOW() - INTERVAL '6 days'),
(9, '這個新買的降噪耳機太扯了，戴上去世界瞬間安靜，根本辦公室防干擾神器。', NOW() - INTERVAL '5 days'),
(10, '有人也覺得晚上的空氣聞起來特別清爽嗎？', NOW() - INTERVAL '5 days'),
(1, 'PostgreSQL 的 Stored Procedure 原來這麼好用！把多個 Table 的更新綁在 Transaction 裡真的超安心。', NOW() - INTERVAL '4 days'),
(2, '發薪水啦！今晚決定去吃那家觀望很久的高級燒肉犒賞自己🤤', NOW() - INTERVAL '4 days'),
(3, '貓咪為什麼對紙箱情有獨鍾？買了幾千塊的貓窩死都不進去...💸', NOW() - INTERVAL '3 days'),
(4, '最近串流平台上的新劇實在太多了，選擇困難症發作，大家都看哪一部？', NOW() - INTERVAL '3 days'),
(5, '咖啡拉花失敗的第 101 天，今天拉出了一個看起來像外星人的東西。', NOW() - INTERVAL '2 days'),
(6, '整理照片發現去年去海邊的照片，好懷念不用穿厚外套的天氣啊～', NOW() - INTERVAL '2 days'),
(7, '推薦大家運動前可以喝點黑咖啡，燃脂效果更好哦！', NOW() - INTERVAL '24 hours'),
(8, '二手書店真的是挖寶的好地方，今天用半價買到了絕版書！', NOW() - INTERVAL '18 hours'),
(9, '聽到一首好歌，單曲循環了一整天還是覺得好好聽🎵', NOW() - INTERVAL '12 hours'),
(10, '系統上線前一天，祈禱一切平安順利，不要有意外發生 🙏', NOW() - INTERVAL '2 hours');

-- 4. 新增留言 (每篇隨機 1~3 則)
INSERT INTO comments (post_id, user_id, content, created_at) VALUES
(1, 2, '太神啦！恭喜解 Bug 🎉', NOW() - INTERVAL '15 days' + INTERVAL '1 hour'),
(1, 5, '工程師絕對需要來杯咖啡慶祝一下☕', NOW() - INTERVAL '15 days' + INTERVAL '3 hours'),
(2, 3, '求地址！看起來太好吃了！', NOW() - INTERVAL '14 days' + INTERVAL '2 hours'),
(3, 4, '我家那隻也是，而且專挑我打 Code 的時候過來踩。', NOW() - INTERVAL '14 days' + INTERVAL '5 hours'),
(3, 6, '真可愛！可以多發一點照片嗎😍', NOW() - INTERVAL '14 days' + INTERVAL '8 hours'),
(4, 8, '結尾的確有點倉促，不過視覺享受還是很夠的。', NOW() - INTERVAL '13 days' + INTERVAL '1 hour'),
(5, 1, '淺焙真的讚！我也喜歡帶點果酸味的。', NOW() - INTERVAL '13 days' + INTERVAL '4 hours'),
(6, 10, '太熱血了吧！我光看文字就覺得好冷。', NOW() - INTERVAL '12 days' + INTERVAL '2 hours'),
(6, 2, '日出好美！看完都想出門了。', NOW() - INTERVAL '12 days' + INTERVAL '6 hours'),
(7, 5, '明天需要我幫你買咖啡送到桌上嗎？🤣', NOW() - INTERVAL '11 days' + INTERVAL '1 hour'),
(8, 1, '這本書我也很推！小小的改變累積起來很可怕的。', NOW() - INTERVAL '11 days' + INTERVAL '3 hours'),
(9, 6, '推薦你聽聽看告五人，最近很喜歡！', NOW() - INTERVAL '10 days' + INTERVAL '1 hour'),
(9, 3, '草東沒有派對！', NOW() - INTERVAL '10 days' + INTERVAL '4 hours'),
(10, 4, '泡麵加顆蛋，人間美味。', NOW() - INTERVAL '10 days' + INTERVAL '30 minutes'),
(11, 8, '最近也在考慮要不要學 Vue，看起來滿友善的。', NOW() - INTERVAL '9 days' + INTERVAL '2 hours'),
(12, 10, '至少嘗試過了啦哈哈，下次會更好的！', NOW() - INTERVAL '9 days' + INTERVAL '1 hour'),
(12, 7, '可以多加點蔬菜，健康一點！', NOW() - INTERVAL '9 days' + INTERVAL '4 hours'),
(13, 2, '海參也太好笑了吧！！！', NOW() - INTERVAL '8 days' + INTERVAL '3 hours'),
(14, 9, '配樂也超經典，Hans Zimmer 真的是神。', NOW() - INTERVAL '8 days' + INTERVAL '2 hours'),
(15, 1, '新品好喝嗎？我也想去買！', NOW() - INTERVAL '7 days' + INTERVAL '1 hour'),
(16, 3, '小樽運河必去！那邊的甜點也超好吃。', NOW() - INTERVAL '7 days' + INTERVAL '5 hours'),
(16, 5, '記得多穿點，那邊真的很冷喔。', NOW() - INTERVAL '7 days' + INTERVAL '8 hours'),
(17, 8, '太有毅力了，佩服佩服！', NOW() - INTERVAL '6 days' + INTERVAL '3 hours'),
(18, 5, '這組合聽起來太完美了☕🍰', NOW() - INTERVAL '6 days' + INTERVAL '2 hours'),
(19, 10, '求型號！辦公室真的很需要。', NOW() - INTERVAL '5 days' + INTERVAL '1 hour'),
(20, 4, '真的！晚上散步超舒服的。', NOW() - INTERVAL '5 days' + INTERVAL '3 hours'),
(21, 6, '沒想到資料庫也能做這麼多事，學到了。', NOW() - INTERVAL '4 days' + INTERVAL '2 hours'),
(22, 1, '燒肉！記得多點一份牛舌😋', NOW() - INTERVAL '4 days' + INTERVAL '1 hour'),
(22, 7, '吃完明天記得來還債(重訓)喔！', NOW() - INTERVAL '4 days' + INTERVAL '4 hours'),
(23, 2, '紙箱才是本體，貓窩只是贈品啦。', NOW() - INTERVAL '3 days' + INTERVAL '1 hour'),
(24, 8, '最近在追絕命律師，大推！', NOW() - INTERVAL '3 days' + INTERVAL '2 hours'),
(24, 9, '黑鏡也不錯看，會讓人一直思考。', NOW() - INTERVAL '3 days' + INTERVAL '6 hours'),
(25, 3, '外星人拉花也是一種藝術👽', NOW() - INTERVAL '2 days' + INTERVAL '1 hour'),
(26, 10, '好想去海邊曬太陽啊～～', NOW() - INTERVAL '2 days' + INTERVAL '2 hours'),
(27, 2, '學到了一招！明天試試看。', NOW() - INTERVAL '24 hours' + INTERVAL '30 minutes'),
(28, 4, '挖到絕版書真的很開心，恭喜！', NOW() - INTERVAL '18 hours' + INTERVAL '2 hours'),
(28, 6, '有機會我也要去逛逛二手書店。', NOW() - INTERVAL '18 hours' + INTERVAL '5 hours'),
(29, 7, '可以分享是哪首歌嗎？', NOW() - INTERVAL '12 hours' + INTERVAL '1 hour'),
(30, 2, '一定沒問題的！加油！', NOW() - INTERVAL '2 hours' + INTERVAL '10 minutes'),
(30, 5, '上線完記得請大家喝飲料慰勞一下XD', NOW() - INTERVAL '2 hours' + INTERVAL '45 minutes');

-- 5. 批次更新計數器 (因為我們是直接大量 INSERT，沒有經過 Procedure，所以需要手動同步一次計數器)
UPDATE users u
SET post_count = (SELECT COUNT(*) FROM posts p WHERE p.user_id = u.id);

UPDATE posts p
SET comment_count = (SELECT COUNT(*) FROM comments c WHERE c.post_id = p.id);