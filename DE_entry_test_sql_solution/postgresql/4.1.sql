CREATE OR REPLACE PROCEDURE price_change(
    accommodationid character varying(12),
    change decimal(10,2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM "ACCOMMODATION" WHERE "AccommodationID" = accommodationid) THEN
        UPDATE "ACCOMMODATION" 
        SET "PricePerNight" = "PricePerNight" + change
        WHERE "AccommodationID" = accommodationid;
    ELSE
        RAISE NOTICE 'Accommodation does not exist';
    END IF;
END;
$$; 