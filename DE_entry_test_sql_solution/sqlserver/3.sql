-- Bulk insert data into PROVINCE table
BULK INSERT PROVINCE
FROM '/data/utf16/province.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Bulk insert data into CITY_DISTRICT table
BULK INSERT CITY_DISTRICT
FROM '/data/utf16/city_district.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Bulk insert data into ACCOMMODATION_TYPE table
BULK INSERT ACCOMMODATION_TYPE
FROM '/data/utf16/accommodation_type.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Bulk insert data into AMENITIES table
BULK INSERT AMENITIES
FROM '/data/utf16/amenities.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Bulk insert data into FACILITIES table
BULK INSERT FACILITIES
FROM '/data/utf16/facilities.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Bulk insert data into ACCOMMODATION table
BULK INSERT ACCOMMODATION
FROM '/data/utf16/accommodation.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Bulk insert data into AMENITIES_INCLUDED table
BULK INSERT AMENITIES_INCLUDED
FROM '/data/utf16/amenities_included.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Bulk insert data into FACILITIES_INCLUDED table
BULK INSERT FACILITIES_INCLUDED
FROM '/data/utf16/facilities_included.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Bulk insert data into VOUCHER_COUPON table
BULK INSERT VOUCHER_COUPON
FROM '/data/utf16/voucher_coupon.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Bulk insert data into BOOKING table
BULK INSERT BOOKING
FROM '/data/utf16/booking.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Bulk insert data into GUEST_ACCOUNT table
BULK INSERT GUEST_ACCOUNT
FROM '/data/utf16/guest_account.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Bulk insert data into OWNER_ACCOUNT table
BULK INSERT OWNER_ACCOUNT
FROM '/data/utf16/owner_account.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Bulk insert data into PAYMENT table
BULK INSERT PAYMENT
FROM '/data/utf16/payment.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Bulk insert data into FEEDBACK table
BULK INSERT FEEDBACK
FROM '/data/utf16/feedback.csv'
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
