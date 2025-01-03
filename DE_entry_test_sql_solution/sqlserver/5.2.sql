-- 5.2. 
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
ORDER BY rs.AvgRating DESC, DifferenceFromTypeAverage DESC, rs.AccommodationID ASC;