--21. Viết thủ tục hiển thị số lượng đơn đặt chỗ, rating trung bình của chỗ ở được truyền vào
--21. Write a Procedure to show Numbers of Booking, Average Rating of the input Accommodation
CREATE PROC solieuchoo
(
	@machoo varchar (12)
)
AS
BEGIN
SELECT B.AccommodationID, A.AccommodationName, Count(B.BookingID) [SO LUONG BOOKING],  ROUND(AVG(CAST(F.Rating AS FLOAT)), 2) [RATING TRUNG BINH]
FROM ACCOMMODATION A
JOIN BOOKING B
ON A.AccommodationID = B.AccommodationID
JOIN FEEDBACK F
ON A.AccommodationID = F.AccommodationID
WHERE A.AccommodationID = @machoo
GROUP BY B.AccommodationID, A.AccommodationName
END