-- 5.4.

-- Simple solution
CREATE PROCEDURE search_accommodations
    @required_capacity INT,
    @required_facilities VARCHAR(MAX) = NULL,
    @required_amenities VARCHAR(MAX) = NULL
AS
BEGIN
    SELECT DISTINCT
        a.AccommodationID,
        a.AccommodationName,
        at.AccommodationType,
        a.PricePerNight,
        a.Capacity,
        a.NumberOfRooms
    FROM ACCOMMODATION a
    JOIN ACCOMMODATION_TYPE at ON a.AccommodationTypeID = at.AccommodationTypeID
    WHERE a.Capacity >= @required_capacity
    AND (@required_facilities IS NULL OR 
        a.AccommodationID IN (
            SELECT AccommodationID 
            FROM FACILITIES_INCLUDED 
            WHERE FacilityID IN (SELECT value FROM STRING_SPLIT(@required_facilities, ','))
            GROUP BY AccommodationID
            HAVING COUNT(*) = (SELECT COUNT(*) FROM STRING_SPLIT(@required_facilities, ','))
        ))
    AND (@required_amenities IS NULL OR 
        a.AccommodationID IN (
            SELECT AccommodationID 
            FROM AMENITIES_INCLUDED 
            WHERE AmenityID IN (SELECT value FROM STRING_SPLIT(@required_amenities, ','))
            GROUP BY AccommodationID
            HAVING COUNT(*) = (SELECT COUNT(*) FROM STRING_SPLIT(@required_amenities, ','))
        ))
    ORDER BY a.PricePerNight;
END;
GO
-- Example execution
EXEC search_accommodations 
    @required_capacity = 18,
    @required_facilities = 'F10,F02',
    @required_amenities = 'A12';





-- Advanced solution
CREATE PROCEDURE search_accommodations_adv
    @required_capacity INT,
    @required_facilities VARCHAR(MAX) = NULL,
    @required_amenities VARCHAR(MAX) = NULL
AS
BEGIN
    SELECT DISTINCT
        a.AccommodationID,
        a.AccommodationName,
        at.AccommodationType,
        a.PricePerNight,
        a.Capacity,
        a.NumberOfRooms,
        STUFF((
            SELECT ', ' + f2.FacilityName
            FROM FACILITIES_INCLUDED fi2
            JOIN FACILITIES f2 ON fi2.FacilityID = f2.FacilityID
            WHERE fi2.AccommodationID = a.AccommodationID
            FOR XML PATH('')), 1, 2, '') AS Facilities,
        STUFF((
            SELECT ', ' + ra2.AmenityName
            FROM AMENITIES_INCLUDED ai2
            JOIN AMENITIES ra2 ON ai2.AmenityID = ra2.AmenityID
            WHERE ai2.AccommodationID = a.AccommodationID
            FOR XML PATH('')), 1, 2, '') AS Amenities
    FROM ACCOMMODATION a
    JOIN ACCOMMODATION_TYPE at ON a.AccommodationTypeID = at.AccommodationTypeID
    LEFT JOIN FACILITIES_INCLUDED fi ON a.AccommodationID = fi.AccommodationID
    LEFT JOIN FACILITIES f ON fi.FacilityID = f.FacilityID
    LEFT JOIN AMENITIES_INCLUDED ai ON a.AccommodationID = ai.AccommodationID
    LEFT JOIN AMENITIES ra ON ai.AmenityID = ra.AmenityID
    WHERE a.Capacity >= @required_capacity
    AND (@required_facilities IS NULL OR 
        a.AccommodationID IN (
            SELECT AccommodationID 
            FROM FACILITIES_INCLUDED 
            WHERE FacilityID IN (SELECT value FROM STRING_SPLIT(@required_facilities, ','))
            GROUP BY AccommodationID
            HAVING COUNT(*) = (SELECT COUNT(*) FROM STRING_SPLIT(@required_facilities, ','))
        ))
    AND (@required_amenities IS NULL OR 
        a.AccommodationID IN (
            SELECT AccommodationID 
            FROM AMENITIES_INCLUDED 
            WHERE AmenityID IN (SELECT value FROM STRING_SPLIT(@required_amenities, ','))
            GROUP BY AccommodationID
            HAVING COUNT(*) = (SELECT COUNT(*) FROM STRING_SPLIT(@required_amenities, ','))
        ))
    GROUP BY 
        a.AccommodationID,
        a.AccommodationName,
        at.AccommodationType,
        a.PricePerNight,
        a.Capacity,
        a.NumberOfRooms
    ORDER BY a.PricePerNight;
END;
GO
-- Example execution:
EXEC search_accommodations_adv
    @required_capacity = 18,
    @required_facilities = 'F10,F02',
    @required_amenities = 'A12';