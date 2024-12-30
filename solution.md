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