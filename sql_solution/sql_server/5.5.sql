-- 5.5. Analyze guest loyalty:
-- - Create a guest loyalty analysis that shows:
-- - Number of bookings per guest
-- - Average length of stay per guest
-- - Total amount spent per guest
-- - Sort by total amount spent in descending order
-- - Only include guests with at least 3 bookings #}

SELECT 
    g.GuestIDCardNumber,
    g.FirstName,
    g.LastName,
    COUNT(b.BookingID) as NumberOfBookings,
    AVG(DATEDIFF(day, b.CheckInTime, b.CheckOutTime)) as AvgLengthOfStay,
    SUM(
        a.PricePerNight * DATEDIFF(day, b.CheckInTime, b.CheckOutTime) - 
        COALESCE(CASE 
                    WHEN vc.DiscountUnit = '%' THEN 
                        (a.PricePerNight * DATEDIFF(day, b.CheckInTime, b.CheckOutTime) * vc.DiscountValue/100)
                    ELSE 
                        vc.DiscountValue -- Fixed amount discount applied once
                END, 0)
    )as TotalAmountSpent
FROM GUEST_ACCOUNT g
JOIN BOOKING b ON g.GuestIDCardNumber = b.GuestIDCardNumber
JOIN ACCOMMODATION a ON b.AccommodationID = a.AccommodationID
LEFT JOIN VOUCHER_COUPON vc ON b.VCCode = vc.VCCode
WHERE b.DateTimeCancel IS NULL -- Only non-cancelled bookings
GROUP BY g.GuestIDCardNumber, g.FirstName, g.LastName
HAVING COUNT(b.BookingID) >= 3
ORDER BY TotalAmountSpent DESC;