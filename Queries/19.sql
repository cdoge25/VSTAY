--19. Viết thủ tục hiển thị danh sách từ ngày … ngày… có những khách hàng nào booking những chỗ ở nào
--19. Write a Procedure showing during the time between … and …, are there any guests and what is their booking
CREATE PROC DANHSACHKHACHHANG
( @intime1 datetime ,
@intime2 datetime)
AS 
SELECT GA.GuestIDCardNumber, GA.FirstName, GA.LastName, GA.IDCardNumber, GA.PhoneNumber, A.AccommodationName, AT.AccommodationType, OA.LastName + '' + OA.FirstName AS [OWNER NAME], A.StreetAddress, A.PricePerNight, B.CheckInTime
FROM BOOKING B
JOIN GUEST_ACCOUNT GA
ON B.GuestIDCardNumber=GA.GuestIDCardNumber
JOIN ACCOMMODATION A
ON B.AccommodationID=A.AccommodationID
JOIN ACCOMMODATION_TYPE AT
ON AT.AccommodationTypeID=A.AccommodationTypeID
JOIN OWNER_ACCOUNT OA
ON OA.OwnerIDCardNumber=A.OwnerIDCardNumber
WHERE B.CheckInTime Between  @intime1 and @intime2
EXECUTE DANHSACHKHACHHANG @intime1='2021-09-19 15:09:55.000', @intime2='2022-03-08 02:25:47.000'
