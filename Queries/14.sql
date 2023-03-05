--Tạo bảng GIAODICH để tổng hợp số tiền thu từ khách hàng, tiền hoàn trả khách hàng, tiền thanh toán cho chủ nhà và lợi nhuận
--Create a new table GIAODICH to summarize Revenue (from Customers), Chargeback (to Customers), Payment (to Owners), Profit

--a) Thêm BookingID, GIA CHO THUE, THU KHACH HANG, HOAN TRA KHACH HANG
--a) Add BookingID, PRICE FOR RENT, REVENUE, CHARGEBACK
SELECT B.BookingID [MA DAT CHO],
		
		A.PricePerNight * datediff(day, B.CheckInTime, B.CheckOutTime) [GIA CHO THUE],

		IIF (D.DiscountValue>A.PricePerNight * datediff(day, B.CheckInTime, B.CheckOutTime),0,  --Nếu discount lớn hơn giá phòng thì không thu tiền
		1.05 * A.PricePerNight * datediff(day, B.CheckInTime, B.CheckOutTime)					--Thu KH = 105% x giá cho thuê - discount
		- IIF (B.DiscountCode is null, 0, (IIF (D.DiscountValue>100, D.DiscountValue,			
		D.DiscountValue/100 * A.PricePerNight * datediff(day, B.CheckInTime, B.CheckOutTime))))) [THU KHACH HANG],

		IIF (D.DiscountValue>A.PricePerNight * datediff(day, B.CheckInTime, B.CheckOutTime),0,	--Giá cho thuê =0 thì không hoàn tiền
		IIF (B.DateTimeCancel is null, 0,														--Đơn nào không huỷ thì không hoàn tiền
		1.05 * A.PricePerNight * datediff(day, B.CheckInTime, B.CheckOutTime)					--Huỷ trước 7 ngày hoàn 100% tổng tiền thu KH
		- IIF (B.DiscountCode is null, 0, IIF (D.DiscountValue>100, D.DiscountValue,			--sau 7 ngày 50%, sau 3 ngày 0%
		D.DiscountValue/100 * A.PricePerNight * datediff(day, B.CheckInTime, B.CheckOutTime))))
		* IIF (datediff(day, B.DateTimeCancel, B.CheckInTime)<3, 0,
		IIF (datediff(day, B.DateTimeCancel, B.CheckInTime)<7, 0.5, 1))) [HOAN TRA KHACH HANG]

INTO GIAODICH
FROM BOOKING B
JOIN ACCOMMODATION A
on B.AccommodationID = A.AccommodationID
LEFT JOIN DISCOUNT D
on B.DiscountCode = D.DiscountCode

--b) Thêm TRA CHU NHA
--b) Add PAYMENT
ALTER TABLE GIAODICH
ADD [TRA CHU NHA]
AS CASE
WHEN [HOAN TRA KHACH HANG] = 0 then [GIA CHO THUE] * 0.95
ELSE ([GIA CHO THUE] - [HOAN TRA KHACH HANG]) * 0.7
END

--c) Thêm LOI NHUAN
--c) Add Profit
ALTER TABLE GIAODICH
ADD [LOI NHUAN]
AS CASE
WHEN [HOAN TRA KHACH HANG] = 0 then [THU KHACH HANG] - [HOAN TRA KHACH HANG] - [GIA CHO THUE] * 0.95
ELSE [THU KHACH HANG] - [HOAN TRA KHACH HANG] - ([GIA CHO THUE] - [HOAN TRA KHACH HANG]) * 0.7
END

----14. Hiển thị những đơn đặt chỗ có tổng chi phí thuê lớn hơn 5000000, sắp xếp theo giá tăng dần
----14. Show Bookings with Price over 5000000, sắp xếp theo giá tăng dần, ascending order
SELECT B.BookingID, A.AccommodationID, A.AccommodationName, A.PricePerNight * datediff(day, B.CheckInTime, B.CheckOutTime) [GIA THUE]
FROM BOOKING B
JOIN ACCOMMODATION A
ON B.AccommodationID = A.AccommodationID
GROUP BY B.BookingID, A.AccommodationID, A.AccommodationName, A.PricePerNight, B.CheckInTime, B.CheckOutTime
HAVING A.PricePerNight * datediff(day, B.CheckInTime, B.CheckOutTime) > 5000000
ORDER BY A.PricePerNight * datediff(day, B.CheckInTime, B.CheckOutTime)
