-- Simple solution
CREATE OR REPLACE PROCEDURE search_accommodations(
    required_capacity INTEGER,
    required_facilities TEXT DEFAULT NULL,
    required_amenities TEXT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    DROP TABLE IF EXISTS search_results;
    CREATE TEMP TABLE search_results AS
    SELECT DISTINCT
        a."AccommodationID",
        a."AccommodationName",
        at."AccommodationType",
        a."PricePerNight",
        a."Capacity",
        a."NumberOfRooms"
    FROM "ACCOMMODATION" a
    JOIN "ACCOMMODATION_TYPE" at ON a."AccommodationTypeID" = at."AccommodationTypeID"
    WHERE a."Capacity" >= required_capacity
    AND (required_facilities IS NULL OR 
        a."AccommodationID" IN (
            SELECT "AccommodationID" 
            FROM "FACILITIES_INCLUDED" 
            WHERE "FacilityID" = ANY(string_to_array(required_facilities, ','))
            GROUP BY "AccommodationID"
            HAVING COUNT(*) = array_length(string_to_array(required_facilities, ','), 1)
        ))
    AND (required_amenities IS NULL OR 
        a."AccommodationID" IN (
            SELECT "AccommodationID" 
            FROM "AMENITIES_INCLUDED" 
            WHERE "AmenityID" = ANY(string_to_array(required_amenities, ','))
            GROUP BY "AccommodationID"
            HAVING COUNT(*) = array_length(string_to_array(required_amenities, ','), 1)
        ))
    ORDER BY a."PricePerNight";

    -- Return results
    RAISE NOTICE 'Query completed. Use SELECT * FROM search_results to view results.';
END;
$$;

-- Example executions:
CALL search_accommodations(18, 'F10,F02', 'A12');
-- View results:
-- SELECT * FROM search_results;


-- Advanced solution with facility and amenity details
CREATE OR REPLACE PROCEDURE search_accommodations_adv(
    required_capacity INTEGER,
    required_facilities TEXT DEFAULT NULL,
    required_amenities TEXT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    DROP TABLE IF EXISTS search_results_adv;
    CREATE TEMP TABLE search_results_adv AS
    SELECT DISTINCT
        a."AccommodationID",
        a."AccommodationName",
        at."AccommodationType",
        a."PricePerNight",
        a."Capacity",
        a."NumberOfRooms",
        string_agg(DISTINCT f."FacilityName", ', ') AS "Facilities",
        string_agg(DISTINCT am."AmenityName", ', ') AS "Amenities"
    FROM "ACCOMMODATION" a
    JOIN "ACCOMMODATION_TYPE" at ON a."AccommodationTypeID" = at."AccommodationTypeID"
    LEFT JOIN "FACILITIES_INCLUDED" fi ON a."AccommodationID" = fi."AccommodationID"
    LEFT JOIN "FACILITIES" f ON fi."FacilityID" = f."FacilityID"
    LEFT JOIN "AMENITIES_INCLUDED" ai ON a."AccommodationID" = ai."AccommodationID"
    LEFT JOIN "AMENITIES" am ON ai."AmenityID" = am."AmenityID"
    WHERE a."Capacity" >= required_capacity
    AND (required_facilities IS NULL OR 
        a."AccommodationID" IN (
            SELECT "AccommodationID" 
            FROM "FACILITIES_INCLUDED" 
            WHERE "FacilityID" = ANY(string_to_array(required_facilities, ','))
            GROUP BY "AccommodationID"
            HAVING COUNT(*) = array_length(string_to_array(required_facilities, ','), 1)
        ))
    AND (required_amenities IS NULL OR 
        a."AccommodationID" IN (
            SELECT "AccommodationID" 
            FROM "AMENITIES_INCLUDED" 
            WHERE "AmenityID" = ANY(string_to_array(required_amenities, ','))
            GROUP BY "AccommodationID"
            HAVING COUNT(*) = array_length(string_to_array(required_amenities, ','), 1)
        ))
    GROUP BY 
        a."AccommodationID",
        a."AccommodationName",
        at."AccommodationType",
        a."PricePerNight",
        a."Capacity",
        a."NumberOfRooms"
    ORDER BY a."PricePerNight";

    -- Return results
    RAISE NOTICE 'Query completed. Use SELECT * FROM search_results_adv to view results.';
END;
$$;

CALL search_accommodations_adv(18, 'F10,F02', 'A12');
-- View results:
-- SELECT * FROM search_results_adv; 