--5. Hiển thị mã chỗ ở, Số CCCD của chủ nhà, giá thuê mỗi đêm, rating trung bình của những chỗ ở có rating trung bình lớn hơn 4. 
--5. Show Accommodation ID, Owner ID Card Number, Price per night, Average Rating of Accommodations with Average Rating over 4.
SELECT a.AccommodationID as 'MA CHO O', a.OwnerIDCardNumber as 'MA CHU CHO THUE', a.PricePerNight as 'GIA MOI DEM', ROUND(AVG(CAST(f.Rating AS FLOAT)), 2) as  'RATING TRUNG BINH'
FROM ACCOMMODATION a
JOIN FEEDBACK f
ON a.AccommodationID = f.AccommodationID
group by a.AccommodationID, a.OwnerIDCardNumber, a.PricePerNight
having ROUND(AVG(CAST(f.Rating AS FLOAT)), 2) > 4 