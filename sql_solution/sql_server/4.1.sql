-- 4.1. price_change procedure
CREATE PROCEDURE price_change
@accommodationid varchar(12),
@change DECIMAL(10,2)
AS
BEGIN
IF EXISTS
(SELECT *
FROM ACCOMMODATION 
)
UPDATE ACCOMMODATION 
SET PricePerNight = PricePerNight + @change
WHERE AccommodationID like @accommodationid
ELSE PRINT N' Accommodation does not exist'
END;