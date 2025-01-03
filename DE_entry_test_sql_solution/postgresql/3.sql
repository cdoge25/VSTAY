-- Load data into tables using PostgreSQL COPY command
COPY "PROVINCE" FROM '/data/province.csv' WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY "CITY_DISTRICT" FROM '/data/city_district.csv' WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY "ACCOMMODATION_TYPE" FROM '/data/accommodation_type.csv' WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY "AMENITIES" FROM '/data/amenities.csv' WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY "FACILITIES" FROM '/data/facilities.csv' WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY "ACCOMMODATION" FROM '/data/accommodation.csv' WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY "AMENITIES_INCLUDED" FROM '/data/amenities_included.csv' WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY "FACILITIES_INCLUDED" FROM '/data/facilities_included.csv' WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY "VOUCHER_COUPON" FROM '/data/voucher_coupon.csv' WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY "BOOKING" FROM '/data/booking.csv' WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY "GUEST_ACCOUNT" FROM '/data/guest_account.csv' WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY "OWNER_ACCOUNT" FROM '/data/owner_account.csv' WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY "PAYMENT" FROM '/data/payment.csv' WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);

COPY "FEEDBACK" FROM '/data/feedback.csv' WITH (
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

-- Remove carriage returns from all text fields
DO $$
DECLARE
    r record;
BEGIN
    FOR r IN SELECT table_name, column_name 
             FROM information_schema.columns 
             WHERE data_type IN ('character varying', 'text')
    LOOP
        EXECUTE format('
            UPDATE %I 
            SET %I = regexp_replace(%I, E''[\n\r]+'', '''', ''g'') 
            WHERE %I ~ E''[\n\r]''', 
            r.table_name, r.column_name, r.column_name, r.column_name);
    END LOOP;
END $$; 