-- Load data into PROVINCE table
LOAD DATA INFILE '/var/lib/mysql-files/data/utf8/province.csv'
INTO TABLE PROVINCE
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Load data into CITY_DISTRICT table
LOAD DATA INFILE '/var/lib/mysql-files/data/utf8/city_district.csv'
INTO TABLE CITY_DISTRICT
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Load data into ACCOMMODATION_TYPE table
LOAD DATA INFILE '/var/lib/mysql-files/data/utf8/accommodation_type.csv'
INTO TABLE ACCOMMODATION_TYPE
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Load data into AMENITIES table
LOAD DATA INFILE '/var/lib/mysql-files/data/utf8/amenities.csv'
INTO TABLE AMENITIES
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Load data into FACILITIES table
LOAD DATA INFILE '/var/lib/mysql-files/data/utf8/facilities.csv'
INTO TABLE FACILITIES
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Load data into GUEST_ACCOUNT table
LOAD DATA INFILE '/var/lib/mysql-files/data/utf8/guest_account.csv'
INTO TABLE GUEST_ACCOUNT
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Load data into OWNER_ACCOUNT table
LOAD DATA INFILE '/var/lib/mysql-files/data/utf8/owner_account.csv'
INTO TABLE OWNER_ACCOUNT
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Load data into ACCOMMODATION table
LOAD DATA INFILE '/var/lib/mysql-files/data/utf8/accommodation.csv'
INTO TABLE ACCOMMODATION
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Load data into AMENITIES_INCLUDED table
LOAD DATA INFILE '/var/lib/mysql-files/data/utf8/amenities_included.csv'
INTO TABLE AMENITIES_INCLUDED
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Load data into FACILITIES_INCLUDED table
LOAD DATA INFILE '/var/lib/mysql-files/data/utf8/facilities_included.csv'
INTO TABLE FACILITIES_INCLUDED
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Load data into VOUCHER_COUPON table
LOAD DATA INFILE '/var/lib/mysql-files/data/utf8/voucher_coupon.csv'
INTO TABLE VOUCHER_COUPON
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Load data into BOOKING table
LOAD DATA INFILE '/var/lib/mysql-files/data/utf8/booking.csv'
INTO TABLE BOOKING
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Load data into PAYMENT table
LOAD DATA INFILE '/var/lib/mysql-files/data/utf8/payment.csv'
INTO TABLE PAYMENT
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Load data into FEEDBACK table
LOAD DATA INFILE '/var/lib/mysql-files/data/utf8/feedback.csv'
INTO TABLE FEEDBACK
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Update the Rating column to convert stars to numbers
UPDATE FEEDBACK
SET Rating = CASE 
    WHEN Rating = '*****' THEN '5'
    WHEN Rating = '****' THEN '4'
    WHEN Rating = '***' THEN '3'
    WHEN Rating = '**' THEN '2'
    WHEN Rating = '*' THEN '1'
    END;

-- Alter FEEDBACK table to change Rating column to INT
ALTER TABLE FEEDBACK
MODIFY COLUMN Rating INT;

-- Remove carriage returns from all text columns in all tables
SET @tables = NULL;
SELECT GROUP_CONCAT('`', table_name, '`') INTO @tables
FROM information_schema.tables 
WHERE table_schema = DATABASE();

SET @sql = NULL;
SELECT GROUP_CONCAT(
    'UPDATE ', table_name, ' SET ',
    GROUP_CONCAT(column_name, ' = REPLACE(REPLACE(', column_name, ', CHAR(13), ''''), CHAR(10), '''')')
    SEPARATOR '; ')
INTO @sql
FROM information_schema.columns
WHERE table_schema = DATABASE()
AND data_type IN ('varchar', 'text', 'char')
GROUP BY table_name;

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt; 


SET FOREIGN_KEY_CHECKS=1;
-- After loading, let's check for any mismatches
SELECT DISTINCT ai.AmenityID 
FROM AMENITIES_INCLUDED ai
LEFT JOIN AMENITIES a ON ai.AmenityID = a.AmenityID
WHERE a.AmenityID IS NULL; 