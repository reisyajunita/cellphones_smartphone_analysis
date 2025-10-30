-- ======================================================================
-- ----------------------    📊 DATA ANALYSIS   ------------------------
-- ======================================================================
-- Project      : Cellphones Data Analysis
-- Author       : Reisya Junita Putri
-- Description: Script ini berisi semua query data analysis untuk
--              menjawab semua pertanyaan bisnis dan memberikan insight
--              yang dapat ditindaklanjuti untuk perkembangan bisnis.
-- ======================================================================

-- 1. Apakah terdapat perbedaan minat pelanggan terhadap merek smartphone di 
-- berbagai segmen pekerjaan, yang diukur melalui rata-rata rating pengguna?

-- Query 1.1: Analisis Merek vs. Rating Sempurna (10)
-- Tujuan: Mengidentifikasi merek mana yang paling banyak menerima rating 10.
SELECT 
    cd.brand AS brand, 
    COUNT(*) AS total_rating_10
FROM cellphones_ratings AS cr
LEFT JOIN cellphones_data AS cd ON cd.cellphone_id = cr.cellphone_id
WHERE cr.rating = 10
GROUP BY brand
ORDER BY total_rating_10 DESC;

-- Query 1.2: Analisis Pekerjaan vs. Rating Sempurna (10)
-- Tujuan: Mengidentifikasi segmen pekerjaan mana yang paling banyak memberi rating 10.
SELECT 
    cu.job AS job, 
    COUNT(*) AS total_rating_10
FROM cellphones_ratings AS cr
LEFT JOIN cellphones_users AS cu ON cu.user_id = cr.user_id
WHERE cr.rating = 10
GROUP BY job
ORDER BY total_rating_10 DESC;

-- INSIGHT (Temuan dari Query 1.1 & 1.2):
-- Analisis rata-rata (AVG) kurang informatif karena banyaknya rating 10.
-- Analisis jumlah (COUNT) rating 10 menunjukkan dua pola kuat:
-- 1. Dari sisi Merek: APPLE (47) dan SAMSUNG (28) adalah merek yang paling banyak
--    menerima rating 10, mengindikasikan kepuasan pelanggan tertinggi.
-- 2. Dari sisi Pekerjaan: Segmen 'Teknologi' (Information Technology, Software Developer, IT)
--    adalah segmen yang paling aktif memberikan rating 10 (total 43).

-- ----------------------------------------------------------------------

-- 2. Model smartphone manakah yang memiliki rating rendah padahal memiliki 
-- spesifikasi tinggi (misal: RAM/Baterai besar), yang mungkin mengindikasikan 
-- ketidakcocokan target pasar?

SELECT 
    cd.brand as brand, 
    cd.model as model, 
    cd.RAM as RAM, 
    cd.battery_size as battery_size, 
    ROUND(AVG(cr.rating), 2) AS avg_rating
FROM cellphones_ratings AS cr
LEFT JOIN cellphones_data AS cd ON cd.cellphone_id = cr.cellphone_id
GROUP BY cd.brand, cd.model, cd.RAM, cd.battery_size
HAVING avg_rating < 6 AND RAM > 8;

-- INSIGHT (Temuan dari Query 2):
-- Tidak ditemukan data HP yang memiliki spesifikasi tinggi (RAM > 8)
-- sekaligus memiliki rata-rata rating rendah (avg_rating < 6).
-- Ini mengindikasikan bahwa HP dengan spesifikasi tinggi di dataset ini
-- umumnya memiliki performa yang baik dan diterima positif oleh pengguna.

-- ----------------------------------------------------------------------

-- 3. Bagaimana perbandingan harga smartphone di berbagai segmen pekerjaan? Apakah segmen
-- pekerjaan tertentu cenderung membeli HP dengan harga rata-rata yang lebih tinggi?

SELECT 
    cu.job as job, 
    ROUND(AVG(cd.price), 2) AS avg_price,
    COUNT(cu.job) AS total_pembelian
FROM cellphones_ratings AS cr
LEFT JOIN cellphones_users AS cu ON cu.user_id = cr.user_id
LEFT JOIN cellphones_data AS cd ON cd.cellphone_id = cr.cellphone_id
GROUP BY cu.job
ORDER BY avg_price DESC;

-- INSIGHT (Temuan dari Query 3):
-- Terdapat perbedaan daya beli antar segmen pekerjaan.
-- Pekerjaan 'Technician' ($794.90) memiliki rata-rata harga beli HP tertinggi,
-- diikuti oleh 'Sales Manager' ($763.85) dan 'Master Degree' ($759.00).


-- ======================================================================
-- ----------------- 🚀 EXPORT MASTER DATA FOR TABLEAU ------------------
-- ======================================================================
-- Query ini menggabungkan semua data yang sudah bersih menjadi satu
-- "master table" untuk diekspor ke CSV dan diimpor ke Tableau
-- untuk visualisasi dan pembuatan dashboard.
-- ======================================================================

SELECT 
    -- Kolom dari data HP
    cd.brand,
    cd.model,
    cd.operating_system,
    cd.internal_memory,
    cd.RAM,
    cd.performance,
    cd.main_camera,
    cd.selfie_camera,
    cd.battery_size,
    cd.screen_size,
    cd.price,
    cd.release_date,
    
    -- Kolom dari data user
    cu.age,
    cu.gender,
    cu.job,
    
    -- Kolom dari data rating
    cr.rating
    
FROM cellphones_ratings AS cr
LEFT JOIN cellphones_users AS cu ON cu.user_id = cr.user_id
LEFT JOIN cellphones_data AS cd ON cd.cellphone_id = cr.cellphone_id;

-- ======================================================================
-- --------------------- AKHIR SCRIPT ANALYSIS --------------------------
-- ======================================================================