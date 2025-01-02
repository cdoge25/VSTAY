-- 5.6 Show for each owner:
-- - Number of properties owned
-- - Number of unique guests
-- - Occupancy rate (days booked / total available days)
-- - Sort by occupancy rate in descending order
-- - Only include owners with more than 2 unique guests

SELECT 
    o.OwnerIDCardNumber,
    CONCAT(o.FirstName, ' ', o.LastName) as FullName,
    COUNT(DISTINCT a.AccommodationID) as NumberOfProperties,
    COUNT(DISTINCT b.GuestIDCardNumber) as UniqueGuests,
    -- Calculate occupancy rate: (total days booked / (365 days * number of properties)) * 100
    ROUND(
        CAST(SUM(DATEDIFF(day, b.CheckInTime, b.CheckOutTime)) as FLOAT) / 
        NULLIF(COUNT(DISTINCT a.AccommodationID) * 365, 0) * 100, 
    2) as OccupancyRate
FROM OWNER_ACCOUNT o
JOIN ACCOMMODATION a ON o.OwnerIDCardNumber = a.OwnerIDCardNumber
LEFT JOIN BOOKING b ON a.AccommodationID = b.AccommodationID 
    AND b.DateTimeCancel IS NULL -- Only include non-cancelled bookings
GROUP BY o.OwnerIDCardNumber, CONCAT(o.FirstName, ' ', o.LastName)
HAVING COUNT(DISTINCT b.GuestIDCardNumber) > 2
ORDER BY OccupancyRate DESC; 