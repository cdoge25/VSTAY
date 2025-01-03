-- PostgreSQL version using crosstab
CREATE EXTENSION IF NOT EXISTS tablefunc;

WITH accommodation_counts AS (
    SELECT 
        p."ProvinceName",
        at."AccommodationType",
        COUNT(*) as count
    FROM "ACCOMMODATION" a
    JOIN "ACCOMMODATION_TYPE" at ON a."AccommodationTypeID" = at."AccommodationTypeID"
    JOIN "CITY_DISTRICT" cd ON a."CityDistrictID" = cd."CityDistrictID"
    JOIN "PROVINCE" p ON cd."ProvinceID" = p."ProvinceID"
    GROUP BY p."ProvinceName", at."AccommodationType"
)
SELECT *
FROM crosstab(
    'SELECT "ProvinceName", 
            "AccommodationType",
            count::integer
     FROM accommodation_counts
     ORDER BY 1,2',
    'SELECT DISTINCT "AccommodationType" 
     FROM "ACCOMMODATION_TYPE" 
     ORDER BY 1'
)
AS ct ("ProvinceName" text,
       -- Add column names dynamically based on your accommodation types
       "Hotel" integer,
       "Resort" integer,
       "Villa" integer
       -- Add more as needed
); 