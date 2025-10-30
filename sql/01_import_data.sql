-- ======================================================================
-- --------------------📂 IMPORT DATA SCRIPT -------------------------
-- Project: Cellphones Data Analysis
-- Description: Script untuk mengimport data ke dalam database MySQL
-- ======================================================================

USE cellphones;

-- -----------------------------------------
-- 1. IMPORT DATASET CELLPHONES
-- -----------------------------------------
DROP TABLE IF EXISTS cellphones_data;

CREATE TABLE cellphones_data (
    cellphone_id INT PRIMARY KEY,
    brand VARCHAR(50),
    model VARCHAR(100),
    operating_system VARCHAR(50),
    internal_memory INT,
    RAM INT,
    performance FLOAT,
    main_camera INT,
    selfie_camera INT,
    battery_size INT,
    screen_size FLOAT,
    weight INT,
    price INT,
    release_date VARCHAR(20)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cellphones data.csv'
INTO TABLE cellphones_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@cellphone_id, @brand, @model, @operating_system, 
 @internal_memory, @RAM, @performance, @main_camera, 
 @selfie_camera, @battery_size, @screen_size, @weight, 
 @price, @release_date)
SET
cellphone_id   = NULLIF(TRIM(@cellphone_id), ''),
brand           = NULLIF(TRIM(@brand), ''),
model           = NULLIF(TRIM(@model), ''),
operating_system= NULLIF(TRIM(@operating_system), ''),
internal_memory = NULLIF(TRIM(@internal_memory), ''),
RAM             = NULLIF(TRIM(@RAM), ''),
performance     = NULLIF(TRIM(@performance), ''),
main_camera     = NULLIF(TRIM(@main_camera), ''),
selfie_camera   = NULLIF(TRIM(@selfie_camera), ''),
battery_size    = NULLIF(TRIM(@battery_size), ''),
screen_size     = NULLIF(TRIM(@screen_size), ''),
weight          = NULLIF(TRIM(@weight), ''),
price           = NULLIF(TRIM(@price), ''),
release_date    = NULLIF(TRIM(@release_date), '');

-- -----------------------------------------
-- 2. IMPORT DATASET RATING CELLPHONES
-- -----------------------------------------
DROP TABLE IF EXISTS cellphones_ratings;

CREATE TABLE cellphones_ratings (
    user_id INT,
    cellphone_id INT,
    rating INT,
    PRIMARY KEY(user_id, cellphone_id)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cellphones ratings.csv'
INTO TABLE cellphones_ratings
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@user_id, @cellphone_id, @rating)
SET
user_id = NULLIF(TRIM(@user_id), ''),
cellphone_id = NULLIF(TRIM(@cellphone_id), ''),
rating = NULLIF(TRIM(@rating), '');

-- -----------------------------------------
-- 3. IMPORT DATASET USERS CELLPHONES
-- -----------------------------------------
DROP TABLE IF EXISTS cellphones_users;

CREATE TABLE cellphones_users (
    user_id INT PRIMARY KEY,
    age INT,
    gender VARCHAR(25),
    job VARCHAR (50)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cellphones users.csv'
INTO TABLE cellphones_users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@user_id, @age, @gender, @job)
SET
user_id = NULLIF(TRIM(@user_id), ''),
age = NULLIF(TRIM(@age), ''),
gender = NULLIF(TRIM(@gender), ''),
job = NULLIF(TRIM(@job), '');

-- -----------------------------------------
-- 4. RELASI ANTAR TABEL (FOREIGN KEY)
-- -----------------------------------------
ALTER TABLE cellphones_ratings
ADD CONSTRAINT fk_rating_user
FOREIGN KEY (user_id)
REFERENCES cellphones_users(user_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE cellphones_ratings
ADD CONSTRAINT fk_rating_cellphone
FOREIGN KEY (cellphone_id)
REFERENCES cellphones_data(cellphone_id)
ON DELETE CASCADE
ON UPDATE CASCADE;