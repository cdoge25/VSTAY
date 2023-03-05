--15. Hiển thị tất cả tiện nghi của những chỗ ở có giá thuê mỗi đêm từ 2000000 - 2500000 VND.
--15. Show amenities of accommodations with Price per night from 2000000 - 2500000 VND.
SELECT A.AccommodationID [NOI O], RA.AmenityName [TIEN NGHI], A.PricePerNight [GIA MOI DEM]
FROM ACCOMMODATION A
JOIN AMENITIES_INCLUDED AI
on A.AccommodationID = AI.AccommodationID
JOIN ROOM_AMENITIES RA
on AI.AmenityID = RA.AmenityID
where A.PricePerNight between 2000000 and 2500000
