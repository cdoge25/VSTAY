-- Bulk insert data into PROVINCE table
BULK INSERT PROVINCE
FROM '/data/province.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Bulk insert data into CITY_DISTRICT table
BULK INSERT CITY_DISTRICT
FROM '/data/city_district.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Bulk insert data into ACCOMMODATION_TYPE table
BULK INSERT ACCOMMODATION_TYPE
FROM '/data/accommodation_type.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Bulk insert data into AMENITIES table
BULK INSERT AMENITIES
FROM '/data/amenities.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Bulk insert data into FACILITIES table
BULK INSERT FACILITIES
FROM '/data/facilities.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Bulk insert data into ACCOMMODATION table
BULK INSERT ACCOMMODATION
FROM '/data/accommodation.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Bulk insert data into AMENITIES_INCLUDED table
BULK INSERT AMENITIES_INCLUDED
FROM '/data/amenities_included.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Bulk insert data into FACILITIES_INCLUDED table
BULK INSERT FACILITIES_INCLUDED
FROM '/data/facilities_included.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Bulk insert data into VOUCHER_COUPON table
BULK INSERT VOUCHER_COUPON
FROM '/data/voucher_coupon.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Bulk insert data into BOOKING table
BULK INSERT BOOKING
FROM '/data/booking.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Bulk insert data into GUEST_ACCOUNT table
BULK INSERT GUEST_ACCOUNT
FROM '/data/guest_account.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Bulk insert data into OWNER_ACCOUNT table
BULK INSERT OWNER_ACCOUNT
FROM '/data/owner_account.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Bulk insert data into PAYMENT_TYPE table
BULK INSERT PAYMENT_TYPE
FROM '/data/payment_type.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Bulk insert data into PAYMENT table
BULK INSERT PAYMENT
FROM '/data/payment.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Bulk insert data into FEEDBACK table
BULK INSERT FEEDBACK
FROM '/data/feedback.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- After bulk insert, update the Rating column to convert stars to numbers
UPDATE FEEDBACK
SET Rating = CASE 
    WHEN Rating = '*****' THEN '5'
    WHEN Rating = '****' THEN '4'
    WHEN Rating = '***' THEN '3'
    WHEN Rating = '**' THEN '2'
    WHEN Rating = '*' THEN '1'
    END;
ALTER TABLE FEEDBACK
ALTER COLUMN Rating INT;


-- Remove carriage return from all tables
DECLARE @sql NVARCHAR(MAX) = '';
-- Generate the UPDATE statements for each column that might contain CHAR(13) or CHAR(10)
SELECT @sql = @sql + 
    'UPDATE [' + TABLE_NAME + '] SET [' + COLUMN_NAME + '] = REPLACE(REPLACE([' + COLUMN_NAME + '], CHAR(13), ''''), CHAR(10), '''') WHERE [' + COLUMN_NAME + '] LIKE ''%' + CHAR(13) + '%'' OR [' + COLUMN_NAME + '] LIKE ''%' + CHAR(10) + '%'';' + CHAR(13)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE DATA_TYPE IN ('varchar', 'nvarchar', 'text', 'ntext');
-- Print the generated SQL (for verification) and execute it
PRINT @sql;
EXEC sp_executesql @sql;
