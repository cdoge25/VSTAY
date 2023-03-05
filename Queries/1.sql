--1. Hiển thị thông tin của chỗ ở có giá mỗi đêm từ 1200000 VND và có sức chứa là 4 người.
--1. Show Accomodations with Price per night over 1200000 VND and capacity of 4 people.
SELECT A.AccommodationName, AP.AccommodationType, OA.LastName + '' + OA.FirstName AS [OWNER NAME], A.StreetAddress, RA. AmenityName, F.FacilityName 
FROM ACCOMMODATION A
JOIN OWNER_ACCOUNT OA
ON A.OwnerIDCardNumber =OA.OwnerIDCardNumber
JOIN ACCOMMODATION_TYPE AP
ON A.AccommodationTypeID = AP.AccommodationTypeID 
JOIN AMENITIES_INCLUDED AI
ON AI.AccommodationID =A. AccommodationID
JOIN ROOM_AMENITIES RA
ON RA. AmenityID=AI.AmenityID
JOIN FACILITIES_INCLUDED FI
ON A.AccommodationID = FI.AccommodationID 
JOIN FACILITIES F
ON F.FacilityID = FI.FacilityID
WHERE A.PricePerNight >120000 and A.Capacity = 4
