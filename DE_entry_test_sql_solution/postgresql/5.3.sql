-- No dynamic query
SELECT p."ProvinceName", SUM(CASE WHEN at."AccommodationType" = 'Bungalow' THEN 1 ELSE 0 END) AS "Bungalow", SUM(CASE WHEN at."AccommodationType" = 'Condotel' THEN 1 ELSE 0 END) AS "Condotel", SUM(CASE WHEN at."AccommodationType" = 'Duplex' THEN 1 ELSE 0 END) AS "Duplex", SUM(CASE WHEN at."AccommodationType" = 'Farmstay' THEN 1 ELSE 0 END) AS "Farmstay", SUM(CASE WHEN at."AccommodationType" = 'Homestay' THEN 1 ELSE 0 END) AS "Homestay", SUM(CASE WHEN at."AccommodationType" = 'Penthouse' THEN 1 ELSE 0 END) AS "Penthouse", SUM(CASE WHEN at."AccommodationType" = 'Resort' THEN 1 ELSE 0 END) AS "Resort", SUM(CASE WHEN at."AccommodationType" = 'Studio' THEN 1 ELSE 0 END) AS "Studio", SUM(CASE WHEN at."AccommodationType" = 'Treehouse' THEN 1 ELSE 0 END) AS "Treehouse", SUM(CASE WHEN at."AccommodationType" = 'Villa' THEN 1 ELSE 0 END) AS "Villa", COUNT(*) AS "TotalAccommodations" 
FROM "ACCOMMODATION" a
JOIN "ACCOMMODATION_TYPE" at ON a."AccommodationTypeID" = at."AccommodationTypeID"
JOIN "CITY_DISTRICT" cd ON a."CityDistrictID" = cd."CityDistrictID"
JOIN "PROVINCE" p ON cd."ProvinceID" = p."ProvinceID"
GROUP BY p."ProvinceName"
ORDER BY "TotalAccommodations" DESC

--Dynamic query
DO $$ 
DECLARE
    sql_query TEXT;
    rec RECORD;
BEGIN
    -- Drop the temporary table if it already exists
    IF EXISTS (SELECT 1 FROM pg_tables WHERE tablename = 'temp_accommodation_counts') THEN
        EXECUTE 'DROP TABLE temp_accommodation_counts';
    END IF;

    -- Create the temporary table dynamically
    CREATE TEMP TABLE temp_accommodation_counts (
        "ProvinceName" TEXT,
		"TotalAccommodations" BIGINT
    );

    -- Add dynamic columns for each accommodation type
    FOR rec IN
        SELECT "AccommodationType" FROM "ACCOMMODATION_TYPE"
    LOOP
        -- Add a column for each accommodation type
        EXECUTE 'ALTER TABLE temp_accommodation_counts ADD COLUMN "' || rec."AccommodationType" || '" INT DEFAULT 0';
    END LOOP;

    -- Build the dynamic SQL query to insert data into the temporary table
    sql_query := 'INSERT INTO temp_accommodation_counts ("ProvinceName"';

    -- Dynamically add the column names in the query
    FOR rec IN
        SELECT "AccommodationType" FROM "ACCOMMODATION_TYPE"
    LOOP
        sql_query := sql_query || ', "' || rec."AccommodationType" || '"';
    END LOOP;

    sql_query := sql_query || ', "TotalAccommodations"';  -- Add the TotalAccommodations column

    sql_query := sql_query || ') ';

    -- Add the SELECT query to populate the table
    sql_query := sql_query || '
    SELECT p."ProvinceName"';

    -- Add CASE statements for each accommodation type dynamically
    FOR rec IN
        SELECT "AccommodationType" FROM "ACCOMMODATION_TYPE"
    LOOP
        sql_query := sql_query || 
                    ', SUM(CASE WHEN at."AccommodationType" = ''' || rec."AccommodationType" || ''' THEN 1 ELSE 0 END)';
    END LOOP;

    -- Add the COUNT(*) to calculate the total number of accommodations
    sql_query := sql_query || ',
                    COUNT(*) AS "TotalAccommodations"';

    -- Complete the query with the necessary joins and group by
    sql_query := sql_query || '
    FROM "ACCOMMODATION" a
    JOIN "ACCOMMODATION_TYPE" at ON a."AccommodationTypeID" = at."AccommodationTypeID"
    JOIN "CITY_DISTRICT" cd ON a."CityDistrictID" = cd."CityDistrictID"
    JOIN "PROVINCE" p ON cd."ProvinceID" = p."ProvinceID"
    GROUP BY p."ProvinceName"
    ORDER BY "TotalAccommodations" DESC';

    -- Execute the dynamic query to insert the data
    EXECUTE sql_query;

    -- Now you can query the temporary table
    RAISE NOTICE 'Querying temporary table:';
    EXECUTE 'SELECT * FROM temp_accommodation_counts';

END $$;
SELECT * FROM temp_accommodation_counts;

