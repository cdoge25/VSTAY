--3. Hiển thị Số CCCD của khách hàng, mã booking và trạng thái booking của khách hàng có họ là “Halms”.
--3. Show Guest ID Card Number, Booking ID and Booking status of the customer with the last name "Halms" 
SELECT B.BookingID, GA.GuestIDCardNumber, BS.StatusName 
FROM BOOKING B 
JOIN GUEST_ACCOUNT GA
ON B.GuestIDCardNumber = GA.GuestIDCardNumber
JOIN BOOKING_STATUS BS
ON B.BookingStatusID = BS. BookingStatusID 
WHERE GA.LastName ='Halms'
