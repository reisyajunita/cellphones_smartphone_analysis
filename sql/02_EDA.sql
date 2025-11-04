-- ======================================================================
-- ------------------ 📑 EXPLORATORY DATA ANALYSIS ----------------------
-- ======================================================================
-- Project    : Cellphones Data Analysis
-- Author     : Reisya Junita Putri
-- Description: Script ini berisi semua query investigasi (EDA) untuk
--              memahami data, mengidentifikasi masalah kualitas, dan
--              menemukan anomali sebelum proses data cleaning.
-- ======================================================================

USE cellphones;

-- ----------------------------------------------------------------------
-- 1. MEMAHAMI STRUKTUR & UKURAN DATA
-- ----------------------------------------------------------------------
-- Tujuan: Mendapat gambaran umum data, nama kolom, tipe data, dan total baris.

-- Melihat 10 baris pertama dari setiap tabel
SELECT * FROM cellphones_data LIMIT 10;
SELECT * FROM cellphones_ratings LIMIT 10;
SELECT * FROM cellphones_users LIMIT 10;

-- Memeriksa skema tabel (nama kolom, tipe data, dll.)
DESCRIBE cellphones_data;
DESCRIBE cellphones_ratings;
DESCRIBE cellphones_users;

-- Menghitung total baris di setiap tabel
SELECT COUNT(*) AS total_rows_data FROM cellphones_data;
SELECT COUNT(*) AS total_rows_ratings FROM cellphones_ratings;
SELECT COUNT(*) AS total_rows_users FROM cellphones_users;

-- ----------------------------------------------------------------------
-- 2. PENGECEKAN MISSING VALUES (NULL)
-- ----------------------------------------------------------------------
-- Tujuan: Mengidentifikasi jumlah data NULL (kosong murni) di setiap kolom
--         untuk memahami kelengkapan data.

-- Pengecekan NULL di tabel cellphones_data
SELECT COUNT(*) AS total_rows,
    SUM(CASE WHEN brand IS NULL THEN 1 ELSE 0 END) AS null_brand,
    SUM(CASE WHEN model IS NULL THEN 1 ELSE 0 END) AS null_model,
    SUM(CASE WHEN operating_system IS NULL THEN 1 ELSE 0 END) AS null_os,
    SUM(CASE WHEN internal_memory IS NULL THEN 1 ELSE 0 END) AS null_internal_memory,
    SUM(CASE WHEN RAM IS NULL THEN 1 ELSE 0 END) AS null_ram,
    SUM(CASE WHEN performance IS NULL THEN 1 ELSE 0 END) AS null_performance,
    SUM(CASE WHEN main_camera IS NULL THEN 1 ELSE 0 END) AS null_main_camera,
    SUM(CASE WHEN selfie_camera IS NULL THEN 1 ELSE 0 END) AS null_selfie_camera,
    SUM(CASE WHEN battery_size IS NULL THEN 1 ELSE 0 END) AS null_battery_size,
    SUM(CASE WHEN screen_size IS NULL THEN 1 ELSE 0 END) AS null_screen_size,
    SUM(CASE WHEN weight IS NULL THEN 1 ELSE 0 END) AS null_weight,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS null_price,
    SUM(CASE WHEN release_date IS NULL THEN 1 ELSE 0 END) AS null_release_date
FROM cellphones_data;

-- Pengecekan NULL di tabel cellphones_ratings
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS null_rating
FROM cellphones_ratings;

-- Pengecekan NULL di tabel cellphones_users
SELECT COUNT(*) AS total_rows,
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS null_age,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS null_gender,
    SUM(CASE WHEN job IS NULL THEN 1 ELSE 0 END) AS null_job
FROM cellphones_users;

-- ----------------------------------------------------------------------
-- 3. PENGECEKAN DUPLIKAT DATA
-- ----------------------------------------------------------------------
-- Tujuan: Memastikan keunikan data (data integrity), terutama pada
--         kolom Primary Key (ID) atau Composite Key.

-- Cek duplikat Primary Key (cellphone_id) di cellphones_data
WITH SpecDup AS (
    SELECT 
        cellphone_id,
        COUNT(*) AS total_rows
    FROM cellphones_data
    GROUP BY cellphone_id
    HAVING COUNT(*) > 1
)
SELECT * FROM SpecDup;

-- Cek duplikat Composite Key (user_id, cellphone_id) di cellphones_ratings
WITH RatingDup AS (
    SELECT user_id,
        cellphone_id,
        COUNT(*) AS total_rows
    FROM cellphones_ratings
    GROUP BY user_id, cellphone_id
    HAVING COUNT(*) > 1
)
SELECT * FROM RatingDup;

-- Cek duplikat Primary Key (user_id) di cellphones_users
WITH UserDup AS (
    SELECT user_id,
        COUNT(*) AS total_rows
    FROM cellphones_users
    GROUP BY user_id
    HAVING COUNT(*) > 1
)
SELECT * FROM UserDup;

-- ----------------------------------------------------------------------
-- 4. PENGECEKAN INTEGRITAS KUNCI (REFERENTIAL INTEGRITY)
-- ----------------------------------------------------------------------
-- Tujuan: Memastikan setiap Foreign Key (FK) di tabel 'ratings'
--         merujuk ke Primary Key (PK) yang valid di tabel master.
--         (Mencari 'orphaned records' atau data yatim).

-- 4.1. Pengecekan Integritas: cellphones_ratings -> cellphones_data
--      (Apakah ada rating untuk HP yang tidak ada di tabel data?)
SELECT 
    COUNT(cr.cellphone_id) AS rating_tanpa_data_hp
FROM 
    cellphones_ratings cr
LEFT JOIN 
    cellphones_data cd ON cd.cellphone_id = cr.cellphone_id
WHERE 
    cd.cellphone_id IS NULL;

-- 4.2. Pengecekan Integritas: cellphones_ratings -> cellphones_users
--      (Apakah ada rating dari user yang tidak ada di tabel user?)
SELECT 
    COUNT(cr.user_id) AS rating_tanpa_data_user
FROM 
    cellphones_ratings cr
LEFT JOIN 
    cellphones_users cu ON cu.user_id = cr.user_id 
WHERE 
    cu.user_id IS NULL;


-- ----------------------------------------------------------------------
-- 5. UNIVARIATE ANALYSIS
-- ----------------------------------------------------------------------
-- Tujuan: Memeriksa nilai-nilai unik di setiap kolom untuk menemukan:
--         1. Placeholder ('N/A', '-', '', '0', '999', dll.)
--         2. Inkonsistensi data (misal: 'Samsung', 'samsung')
--         3. Nilai aneh/outlier (misal: usia = -1)
--         4. Statistik dasar (MIN, MAX, AVG)

-- 5.1. Tabel: cellphones_data
-- Kolom Kategorikal (Teks)
SELECT brand, COUNT(*) AS total FROM cellphones_data GROUP BY brand ORDER BY total DESC;
SELECT model, COUNT(*) AS total FROM cellphones_data GROUP BY model ORDER BY total DESC;
SELECT operating_system, COUNT(*) AS total FROM cellphones_data GROUP BY operating_system ORDER BY total DESC;

-- Kolom Numerik (Angka)
SELECT internal_memory, COUNT(*) AS total FROM cellphones_data GROUP BY internal_memory ORDER BY internal_memory;
SELECT RAM, COUNT(*) AS total FROM cellphones_data GROUP BY RAM ORDER BY RAM;
SELECT main_camera, COUNT(*) AS total FROM cellphones_data GROUP BY main_camera ORDER BY main_camera;
SELECT selfie_camera, COUNT(*) AS total FROM cellphones_data GROUP BY selfie_camera ORDER BY selfie_camera;
SELECT performance, COUNT(*) AS total FROM cellphones_data GROUP BY performance ORDER BY performance;
SELECT battery_size, COUNT(*) AS total FROM cellphones_data GROUP BY battery_size ORDER BY battery_size;
SELECT screen_size, COUNT(*) AS total FROM cellphones_data GROUP BY screen_size ORDER BY screen_size;
SELECT weight, COUNT(*) AS total FROM cellphones_data GROUP BY weight ORDER BY weight;
SELECT MIN(price) AS min_price, MAX(price) AS max_price, AVG(price) AS avg_price FROM cellphones_data;

-- Kolom Tanggal
SELECT release_date, COUNT(*) AS total FROM cellphones_data GROUP BY release_date ORDER BY release_date;

-- 5.2. Tabel: cellphones_ratings
-- Kolom Numerik (Rating)
SELECT rating, COUNT(*) AS total FROM cellphones_ratings GROUP BY rating ORDER BY rating;

-- 5.3. Tabel: cellphones_users
-- Kolom Numerik (Age)
SELECT MIN(age) AS min_age, MAX(age) AS max_age, ROUND(AVG(age)) AS avg_age FROM cellphones_users;
-- Kolom Kategorikal (Gender, Job)
SELECT gender, COUNT(*) AS total FROM cellphones_users GROUP BY gender;
SELECT job, COUNT(*) AS total FROM cellphones_users GROUP BY job ORDER BY total DESC;

-- ======================================================================
-- --------------------- AKHIR SCRIPT EDA -------------------------------
-- ======================================================================