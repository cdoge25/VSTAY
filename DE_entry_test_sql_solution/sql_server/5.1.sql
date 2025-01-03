-- 5.1.    
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
    LEFT JOIN VOUCHER_COUPON vc ON b.VCCode = vc.VCCode
    WHERE b.DateTimeCancel is NULL
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