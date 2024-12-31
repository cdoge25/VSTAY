# Data Engineer Entry Test - Solutions

## Question 1: Entity Relationship Diagram



## Question 2: Database Schema Creation





### Question 4: Price Change Tracking System
sql
-- Create price history table
CREATE TABLE AccommodationPriceHistory (
HistoryID INT IDENTITY(1,1) PRIMARY KEY,
AccommodationID CHAR(12) NOT NULL,
OldPrice DECIMAL(10,2) NOT NULL,
NewPrice DECIMAL(10,2) NOT NULL,
ChangeDate DATETIME DEFAULT GETDATE(),
FOREIGN KEY (AccommodationID) REFERENCES ACCOMMODATION(AccommodationID)
);
-- Create trigger to track price changes
CREATE TRIGGER trg_Accommodation_PriceChange
ON ACCOMMODATION
AFTER UPDATE
AS
BEGIN
SET NOCOUNT ON;
-- Only track changes to PricePerNight
IF UPDATE(PricePerNight)
BEGIN
INSERT INTO AccommodationPriceHistory (
AccommodationID,
OldPrice,
NewPrice,
ChangedBy
)
SELECT
i.AccommodationID,
d.PricePerNight,
i.PricePerNight,
SYSTEM_USER
FROM inserted i
INNER JOIN deleted d ON i.AccommodationID = d.AccommodationID
WHERE i.PricePerNight != d.PricePerNight;
END;
END;

## Question 5:

1.    
WITH BookingStats AS (
    -- Get non-cancelled bookings with their details
    SELECT 
        at.AccommodationTypeID,
        at.AccommodationType,
        COUNT(*) as TotalBookings,
        AVG(CAST(DATEDIFF(DAY, b.CheckInTime, b.CheckOutTime) as FLOAT)) as AvgStayLength,
        SUM(
            a.PricePerNight * DATEDIFF(day, b.CheckInTime, b.CheckOutTime) - 
            COALESCE(CASE 
                WHEN vc.DiscountUnit = '%' THEN 
                    (a.PricePerNight * DATEDIFF(day, b.CheckInTime, b.CheckOutTime) * vc.DiscountValue/100)
                ELSE 
                    vc.DiscountValue -- Fixed amount discount applied once
            END, 0)
        ) as TotalRevenue
    FROM BOOKING b
    JOIN ACCOMMODATION a ON b.AccommodationID = a.AccommodationID
    JOIN ACCOMMODATION_TYPE at ON a.AccommodationTypeID = at.AccommodationTypeID
    LEFT JOIN [VOUCHER/COUPON] vc ON b.VCCode = vc.VCCode
    WHERE b.BookingStatusID = '01' -- Non-cancelled bookings
    GROUP BY at.AccommodationTypeID, at.AccommodationType
)
SELECT 
    AccommodationType,
    TotalBookings,
    CAST(TotalBookings * 100.0 / SUM(TotalBookings) OVER() as DECIMAL(5,2)) as BookingPercentage,
    CAST(AvgStayLength as DECIMAL(10,2)) as AvgStayLength,
    TotalRevenue,
    CASE 
        WHEN TotalRevenue > AVG(TotalRevenue) OVER() THEN 'Above Average'
        ELSE 'Below Average'
    END as RevenueStatus
FROM BookingStats
ORDER BY TotalRevenue DESC;


2. 
WITH RatingStats AS (
    SELECT 
        a.AccommodationID,
        a.AccommodationName,
        at.AccommodationType,
        a.PricePerNight,
        AVG(CAST(f.Rating as FLOAT)) as AvgRating,
        COUNT(*) as ReviewCount,
        at.AccommodationTypeID
    FROM ACCOMMODATION a
    JOIN ACCOMMODATION_TYPE at ON a.AccommodationTypeID = at.AccommodationTypeID
    JOIN FEEDBACK f ON a.AccommodationID = f.AccommodationID
    GROUP BY 
        a.AccommodationID,
        a.AccommodationName,
        at.AccommodationType,
        a.PricePerNight,
        at.AccommodationTypeID
),
TypeAverages AS (
    -- Calculate average rating per accommodation type
    SELECT 
        at.AccommodationTypeID,
        AVG(CAST(f.Rating as FLOAT)) as TypeAvgRating
    FROM ACCOMMODATION a
    JOIN ACCOMMODATION_TYPE at ON a.AccommodationTypeID = at.AccommodationTypeID
    JOIN FEEDBACK f ON a.AccommodationID = f.AccommodationID
    GROUP BY at.AccommodationTypeID
)
SELECT 
    rs.AccommodationID,
    rs.AccommodationName,
    rs.AccommodationType,
    ROUND(rs.AvgRating, 2) as AverageRating,
    rs.ReviewCount,
    ROUND(ta.TypeAvgRating, 2) as TypeAverageRating,
    ROUND(rs.AvgRating - ta.TypeAvgRating, 2) as DifferenceFromTypeAverage
FROM RatingStats rs
JOIN TypeAverages ta ON rs.AccommodationTypeID = ta.AccommodationTypeID
WHERE rs.AvgRating > 4
ORDER BY rs.AvgRating DESC;

3. 
-- First, get all accommodation types dynamically
DECLARE @sql NVARCHAR(MAX) = 
'SELECT 
    p.ProvinceName,';

-- Add CASE statements for each accommodation type
SELECT @sql = @sql + '
    SUM(CASE WHEN at.AccommodationType = ''' + AccommodationType + ''' THEN 1 ELSE 0 END) AS ' + QUOTENAME(AccommodationType) + ','
FROM ACCOMMODATION_TYPE;

-- Complete the query
SET @sql = @sql + '
    COUNT(*) AS TotalAccommodations
FROM 
    ACCOMMODATION a
    JOIN ACCOMMODATION_TYPE at ON a.AccommodationTypeID = at.AccommodationTypeID
    JOIN [CITY/DISTRICT] cd ON a.[City/DistrictID] = cd.[City/DistrictID]
    JOIN PROVINCE p ON cd.ProvinceID = p.ProvinceID
GROUP BY 
    p.ProvinceName
ORDER BY 
    TotalAccommodations DESC';

EXEC sp_executesql @sql;

--Pivot
DECLARE @cols NVARCHAR(MAX);
DECLARE @query NVARCHAR(MAX);
 
-- Step 1: Get distinct accommodation type values
WITH ProvinceValues AS (
    SELECT DISTINCT AccommodationType
    FROM ACCOMMODATION_TYPE
)
 
-- Step 2: Build dynamic SQL for pivot query
SELECT @cols = STRING_AGG(QUOTENAME(AccommodationType), ', ')
FROM ProvinceValues;
 
-- Step 3: Construct the dynamic SQL query
SET @query = '
SELECT 
    ProvinceName, 
    ' + @cols + ',
    (' + REPLACE(@cols, ', ', ' + ') + ') AS TotalAccommodations
FROM (
    SELECT ProvinceName, AccommodationType
    FROM 
    ACCOMMODATION a
    JOIN ACCOMMODATION_TYPE at ON a.AccommodationTypeID = at.AccommodationTypeID
    JOIN [CITY_DISTRICT] cd ON a.[City_DistrictID] = cd.[City_DistrictID]
    JOIN PROVINCE p ON cd.ProvinceID = p.ProvinceID
) AS SourceTable
PIVOT (
    COUNT(AccommodationType)
    FOR AccommodationType IN (' + @cols + ')
) AS PivotTable
ORDER BY TotalAccommodations DESC;';
 
-- Step 4: Execute the dynamic SQL
EXECUTE(@query);

4.  
--Simple solution
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
    @required_facilities = 'F10',
    @required_amenities = 'A12';

--Advanced solution
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
            JOIN ROOM_AMENITIES ra2 ON ai2.AmenityID = ra2.AmenityID
            WHERE ai2.AccommodationID = a.AccommodationID
            FOR XML PATH('')), 1, 2, '') AS Amenities
    FROM ACCOMMODATION a
    JOIN ACCOMMODATION_TYPE at ON a.AccommodationTypeID = at.AccommodationTypeID
    LEFT JOIN FACILITIES_INCLUDED fi ON a.AccommodationID = fi.AccommodationID
    LEFT JOIN FACILITIES f ON fi.FacilityID = f.FacilityID
    LEFT JOIN AMENITIES_INCLUDED ai ON a.AccommodationID = ai.AccommodationID
    LEFT JOIN ROOM_AMENITIES ra ON ai.AmenityID = ra.AmenityID
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
EXEC search_accommodations 
    @required_capacity = 2,
    @required_facilities = 'F10',
    @required_amenities = 'A12';