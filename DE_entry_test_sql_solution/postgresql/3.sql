-- Load data into tables using PostgreSQL COPY command
COPY "PROVINCE" FROM '/data/utf8/PROVINCE.csv' WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY "CITY_DISTRICT" FROM '/data/utf8/CITY_DISTRICT.csv' WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY "ACCOMMODATION_TYPE" FROM '/data/utf8/ACCOMMODATION_TYPE.csv' WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY "AMENITIES" FROM '/data/utf8/AMENITIES.csv' WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY "FACILITIES" FROM '/data/utf8/FACILITIES.csv' WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY "GUEST_ACCOUNT" FROM '/data/utf8/GUEST_ACCOUNT.csv' WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY "OWNER_ACCOUNT" FROM '/data/utf8/OWNER_ACCOUNT.csv' WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY "ACCOMMODATION" FROM '/data/utf8/ACCOMMODATION.csv' WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY "AMENITIES_INCLUDED" FROM '/data/utf8/AMENITIES_INCLUDED.csv' WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY "FACILITIES_INCLUDED" FROM '/data/utf8/FACILITIES_INCLUDED.csv' WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY "VOUCHER_COUPON" FROM '/data/utf8/VOUCHER_COUPON.csv' WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY "BOOKING" FROM '/data/utf8/BOOKING.csv' WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY "PAYMENT" FROM '/data/utf8/PAYMENT.csv' WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY "FEEDBACK" FROM '/data/utf8/FEEDBACK.csv' WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

-- Update Rating column in FEEDBACK table to convert stars to numbers
UPDATE "FEEDBACK"
SET "Rating" = CASE 
    WHEN "Rating" = '*****' THEN '5'
    WHEN "Rating" = '****' THEN '4'
    WHEN "Rating" = '***' THEN '3'
    WHEN "Rating" = '**' THEN '2'
    WHEN "Rating" = '*' THEN '1'
END;

ALTER TABLE "FEEDBACK" 
ALTER COLUMN "Rating" TYPE INTEGER USING "Rating"::integer;

-- For removing carriage returns:
DO $$
DECLARE
    r record;
BEGIN
    FOR r IN SELECT table_name, column_name 
             FROM information_schema.columns 
             WHERE data_type IN ('character varying', 'text')
             AND table_schema = 'public'  -- Only target user tables in public schema
             AND table_name NOT LIKE 'pg_%'  -- Exclude postgres system tables
    LOOP
        EXECUTE format('
            UPDATE %I 
            SET %I = regexp_replace(%I, E''[\n\r]+'', '''', ''g'') 
            WHERE %I ~ E''[\n\r]''', 
            r.table_name, r.column_name, r.column_name, r.column_name);
    END LOOP;
END $$;