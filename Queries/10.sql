--10. Hiển thị họ tên, Số CCCD của khách hàng, mã booking, mã chỗ ở và tên chỗ ở (nếu có) của những khách hàng hủy booking sau 7 ngày. Sắp xếp ngày hủy của khách theo thứ tự giảm dần. 
--10. Show Full Name, Guest ID Card Number, Booking ID, Accommodation ID of Guests that have cancelled their bookings after 7 days, descending order.
SELECT Concat(firstname, lastname) as [Họ và Tên], ga.GuestIDCardNumber as [Số CCCD của khách hàng], 
       bookingid as [Mã Booking], acc.accommodationid [Mã Chỗ Ở], accommodationname, 
	   statusname [Trạng thái], 
       convert(int, datediff(day, datetimecancel, checkintime))[Ngày Hủy]
FROM booking bk
JOIN guest_account ga
ON bk.GuestIDCardNumber =ga.GuestIDCardNumber 
JOIN booking_status bkst
ON bk.bookingstatusid = bkst.bookingstatusid
join accommodation acc
on bk.accommodationid = acc.accommodationid 
WHERE bk.bookingstatusid = 00 and convert(int, datediff(day, datetimecancel, checkintime)) < 7 
order by 7 desc 
