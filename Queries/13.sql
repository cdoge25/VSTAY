--13. Hiển thị tất cả những booking có áp dụng mã giảm giá thời hạn trong vòng từ "01/09/2021" đến "31/12/2021" nhưng đã bị hủy.
--13. Show Bookings that include Vouchers that are valid from "01/09/2021" to "31/12/2021" but are cancelled.
SELECT B.BookingID, BS.StatusName [TRANG THAI], B.VCCode [MA GIAM GIA], 
		CONVERT (varchar(10), V.ValidFrom, 103) AS [NGAY BAT DAU HIEU LUC],
		CONVERT (varchar(10), V.ValidTo, 103) AS [NGAY HET HIEU LUC]
FROM BOOKING B
JOIN BOOKING_STATUS BS
on B.BookingStatusID = BS.BookingStatusID
JOIN [VOUCHER/COUPON] V
on B.VCCode = V.VCCode
where V.ValidFrom >= '2021-09-01' and V.ValidTo <= '2021-12-31'
	and BS.StatusName = 'Cancelled'
