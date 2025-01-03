WITH BookingStats AS (
    -- Get non-cancelled bookings with their details
    SELECT 
        at."AccommodationTypeID",
        at."AccommodationType",
        COUNT(*) as TotalBookings,
        AVG(CAST(DATE_PART('day', b."CheckOutTime" - b."CheckInTime") as FLOAT)) as AvgStayLength,
        SUM(
            a."PricePerNight" * DATE_PART('day', b."CheckOutTime" - b."CheckInTime") - 
            COALESCE(CASE 
                WHEN vc."DiscountUnit" = '%' THEN 
                    (a."PricePerNight" * DATE_PART('day', b."CheckOutTime" - b."CheckInTime") * vc."DiscountValue"/100)
                ELSE 
                    vc."DiscountValue" -- Fixed amount discount applied once
            END, 0)
        ) as TotalRevenue
    FROM "BOOKING" b
    JOIN "ACCOMMODATION" a ON b."AccommodationID" = a."AccommodationID"
    JOIN "ACCOMMODATION_TYPE" at ON a."AccommodationTypeID" = at."AccommodationTypeID"
    LEFT JOIN "VOUCHER_COUPON" vc ON b."VCCode" = vc."VCCode"
    WHERE b."DateTimeCancel" is NULL
    GROUP BY at."AccommodationTypeID", at."AccommodationType"
)
SELECT 
    "AccommodationType",
    TotalBookings,
    ROUND(CAST(TotalBookings * 100.0 / SUM(TotalBookings) OVER() as NUMERIC), 2) as BookingPercentage,
    ROUND(CAST(AvgStayLength as NUMERIC), 2) as AvgStayLength,
    TotalRevenue,
    CASE 
        WHEN TotalRevenue > AVG(TotalRevenue) OVER() THEN 'Above Average'
        ELSE 'Below Average'
    END as RevenueStatus
FROM BookingStats
ORDER BY TotalRevenue DESC; 