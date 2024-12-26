--7. Procedure to find Province and City of with the input AccommodationID
CREATE PROC location
(@accommodationid varchar(12))
AS
BEGIN
SELECT c.[City/DistrictID] , c.[City/DistrictID], p.ProvinceID, p.ProvinceName
FROM ACCOMMODATION as a
JOIN [CITY/DISTRICT] as c
ON a.[City/DistrictID] = c.[City/DistrictID]
JOIN PROVINCE as p
ON c.ProvinceID = p.ProvinceID
WHERE a.AccommodationID = @accommodationid
END;

--8. Procedure to find accommodations with the input price range
CREATE PROC pricesearch
(@lower numeric(10,0), @upper numeric(10,0))
AS
BEGIN
SELECT *
FROM ACCOMMODATION 
WHERE PricePerNight between @lower and @upper
END;

--9.  Procedure to find customers who has bookings within the ipnut date range
CREATE PROC customer_list
(@lower datetime, @upper datetime)
AS 
SELECT GA.GuestIDCardNumber, GA.FirstName, GA.LastName, GA.GuestIDCardNumber, GA.PhoneNumber, A.AccommodationName, AT.AccommodationType, OA.LastName + '' + OA.FirstName AS [OWNER NAME], A.StreetAddress, A.PricePerNight, B.CheckInTime
FROM BOOKING B
JOIN GUEST_ACCOUNT GA
ON B.GuestIDCardNumber=GA.GuestIDCardNumber
JOIN ACCOMMODATION A
ON B.AccommodationID=A.AccommodationID
JOIN ACCOMMODATION_TYPE AT
ON AT.AccommodationTypeID=A.AccommodationTypeID
JOIN OWNER_ACCOUNT OA
ON OA.OwnerIDCardNumber=A.OwnerIDCardNumber
WHERE B.CheckInTime Between  @lower and @upper

--10. Procedure to increase or decrease the price of a accommodation with the input amount
CREATE PROCEDURE price_change
@accommodationid varchar(12),
@change int
AS
BEGIN
IF EXISTS
(SELECT *
FROM ACCOMMODATION 
)
UPDATE ACCOMMODATION 
SET PricePerNight = PricePerNight + @change
WHERE AccommodationID like @accommodationid
ELSE PRINT N' Accommodation does not exist'
END;

--11. Create trigger to assure checkin time is not in the past
CREATE TRIGGER insert_check on BOOKING
FOR INSERT
AS
IF ((SELECT CheckInTime FROM Inserted) < getdate())
BEGIN
PRINT ('CheckInTime ERROR'); 
PRINT ('CheckInTime cannot be sooner than today'); 
PRINT ('Please check again')
ROLLBACK TRAN
END;