--7. Hiển thị số lượng chỗ ở có số phòng là 2 theo từng loại chỗ ở.
--7. Show number of accomodations with 2 rooms, categorized by Accommodation type
select AccommodationTypeID, count(AccommodationID) as 'Số phòng' 
from ACCOMMODATION
group by AccommodationTypeID, NumberOfRooms
having NumberOfRooms = 2
