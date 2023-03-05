--16. Viết thủ tục hiển thị thành phố và tỉnh của chỗ ở được truyền vào
--16. Write a Procedure showing the City/District and Province of the input AccommodationID
CREATE PROC vitri
 ( @machoo varchar(12))
AS
BEGIN
SELECT c.[City/DistrictID] as 'MA THANH PHO' , c.[City/DistrictID] as 'TEN THANH PHO', p.ProvinceID as 'MA TINH', p.ProvinceName as 'TEN TINH'
FROM ACCOMMODATION as a
JOIN [CITY/DISTRICT] as c
ON a.[City/DistrictID] = c.[City/DistrictID]
JOIN PROVINCE as p
ON c.ProvinceID = p.ProvinceID
WHERE a.AccommodationID = @machoo
END

--Ví dụ nhập vào: 
--Example
exec vitri @machoo =  'ACM000000001'
