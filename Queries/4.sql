--4. Hiển thị giá mỗi đêm cao nhất và giá mỗi đêm thấp nhất của các chỗ ở.
--4. Show the maximum and minumum price per night of Accomodations
SELECT Min(PricePerNight) as 'GIA MOI DEM THAP NHAT', Max(PricePerNight) as 'GIA MOI DEM CAO NHAT'
FROM ACCOMMODATION 
