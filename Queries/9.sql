--9. Hiển thị danh sách mã dịch vụ mà không có dịch vụ “Sauna/Spa”.
--9. Show Facility ID of Facilities without "Sauna/Spa"
select FacilityID
from FACILITIES
except 
select FacilityID
from FACILITIES
where FacilityName = 'Sauna/Spa'
