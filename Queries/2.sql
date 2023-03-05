--2. Hiển thị mã booking, mã chỗ ở, thời gian nhận phòng và trả phòng của booking có trạng thái booking là “Cancelled”. Kết quả được sắp xếp theo thời gian nhận phòng.
--2. Show Booking ID, Accommodation ID, Checkin time, Checkout time of bookings with "Cancelled Status", order by Checkin time
SELECT B.BookingID, A.AccommodationID, B.CheckInTime, B.CheckOutTime 
FROM ACCOMMODATION A
JOIN BOOKING B 
ON A.AccommodationID=B.AccommodationID
JOIN BOOKING_STATUS BS
ON B.BookingStatusID =BS. BookingStatusID 
WHERE BS.StatusName ='Cancelled'
ORDER BY B.CheckInTime
