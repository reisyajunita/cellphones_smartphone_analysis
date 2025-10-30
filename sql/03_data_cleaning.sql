-- ======================================================================
-- ------------------ 📑 DATA CLEANING ----------------------
-- ======================================================================
-- Project      : Cellphones Data Analysis
-- Author       : Reisya Junita Putri
-- Description: Script ini berisi semua query data cleaning untuk
--              membersihkan data yang memiliki nilai hilang, 
--              standarisasi teks, dan mengubah tipe data
--              sebelum proses data analisis.
-- ======================================================================

USE cellphones;

-- ----------------------------------------------------------------------
-- 1. MEMBERSIHKAN TABEL: cellphones_data
-- ----------------------------------------------------------------------

-- 1.1 Standardisasi format kolom 'brand' dan 'operating_system'
-- TUJUAN: Menyeragamkan format teks pada kolom 'brand' dan 'operating_system'.
-- TINDAKAN: Mengubah semua nilai menjadi format UPPERCASE (huruf kapital)
--           untuk memastikan konsistensi absolut saat analisis.
UPDATE cellphones_data
SET brand = UPPER(brand);

UPDATE cellphones_data
SET operating_system = UPPER(operating_system);

-- 1.2 Mengubah tipe data 'release_date'
-- TEMUAN: Tipe data 'release_date' adalah VARCHAR.
-- TINDAKAN: Mengubah tipe data menjadi DATE agar dapat dianalisis.
ALTER TABLE cellphones_data
ADD COLUMN release_date_clean DATE;

-- Mengasumsikan format adalah 'dd/mm/YYYY'
UPDATE cellphones_data
SET release_date_clean = STR_TO_DATE(release_date, '%d/%m/%Y');

ALTER TABLE cellphones_data
DROP COLUMN release_date;

ALTER TABLE cellphones_data
CHANGE release_date_clean release_date DATE;

-- ----------------------------------------------------------------------
-- 2. MEMBERSIHKAN TABEL: cellphones_ratings
-- ----------------------------------------------------------------------
-- TEMUAN (dari 02_EDA.sql): Ditemukan 1 data anomali (rating = 18),
--                          padahal skala rating harusnya 1-10.
-- TINDAKAN: Menghapus data anomali tersebut karena dapat menyebabkan bias.
DELETE FROM cellphones_ratings
WHERE rating > 10;

-- ----------------------------------------------------------------------
-- 3. MEMBERSIHKAN TABEL: cellphones_users
-- ----------------------------------------------------------------------

-- 3.1 Menangani missing values dan standardisasi teks kolom 'gender'
-- TEMUAN (dari 02_EDA.sql): Ditemukan nilai placeholder '-Select Gender-'.
--                          Modus dari kolom ini adalah 'Male'.
-- TINDAKAN: Imputasi placeholder dengan modus ('Male') dan standarisasi ke UPPERCASE.
UPDATE cellphones_users
SET gender = 'Male'
WHERE gender = '-Select Gender-';

UPDATE cellphones_users
SET gender = UPPER(gender);

-- 3.2 Menangani missing values dan standardisasi teks kolom 'job'
-- TEMUAN (dari 02_EDA.sql): Ditemukan nilai placeholder 'null' (teks)
--                          dengan karakter tersembunyi (CHAR(13) atau '\r').
--                          Modus dari kolom ini adalah 'Manager'.
-- TINDAKAN: Imputasi placeholder dengan modus ('Manager') dan standarisasi ke LOWERCASE.
UPDATE cellphones_users
SET job = 'Manager'
WHERE LOWER(REPLACE(job, CHAR(13), '')) = 'null';

UPDATE cellphones_users
SET job = LOWER(job);

-- ======================================================================
-- --------------------- AKHIR SCRIPT DATA CLEANING ---------------------
-- ======================================================================