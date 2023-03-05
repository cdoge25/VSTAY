--6. Hiển thị loại chỗ ở, loại vật dụng và loại dịch vụ của những chỗ ở có số phòng lớn hơn 1 và giá thuê mỗi đêm từ 1000000 - 2000000 VND.
--6. Show Accommodation type, Amenities, Facilities of Accomodations with more than 1 room and Price per night between 1000000 - 2000000 VND.
SELECT a.AccommodationTypeID as 'LOAI CHO O', dc.AmenityID as 'LOAI VAT DUNG', rdc.AmenityName as 'TEN LOAI VAT DUNG' ,dv.FacilityID as 'LOAI DICH VU', f.FacilityName as 'TEN LOAI DICH VU'
FROM ACCOMMODATION as a
JOIN ACCOMMODATION_TYPE as t
ON a.AccommodationTypeID = t.AccommodationTypeID
JOIN AMENITIES_INCLUDED as dc
ON dc.AccommodationID = a.AccommodationID
JOIN ROOM_AMENITIES as rdc
ON dc.AmenityID = rdc.AmenityID
JOIN FACILITIES_INCLUDED as dv
ON a.AccommodationID = dv.AccommodationID
JOIN FACILITIES as f
ON dv.FacilityID = f.FacilityID
WHERE a.NumberOfRooms>1 and a.PricePerNight between 1000000 and 2000000
