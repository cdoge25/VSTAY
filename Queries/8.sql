--8. Hiển thị mã chỗ ở của những chỗ ở tại thành phố “Biên Hòa”.
--8. Show Accommodation ID of accommodations in Bien Hoa city
select a.AccommodationID
from ACCOMMODATION a
join [CITY/DISTRICT] c
on a.[City/DistrictID] = c.[City/DistrictID]
where c.[City/DistrictName] = 'Biên Hòa'
