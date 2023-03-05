--17. Viết thủ tục hiển thị những chỗ ở có giá tiền một đêm từ… đến…
--17. Write a Procedure showing accommodations by inputting price range
CREATE PROC tracuugia
 ( @giatien1 numeric(10,0),
   @giatien2 numeric(10,0))
AS
BEGIN
SELECT *
FROM ACCOMMODATION 
WHERE PricePerNight between @giatien1 and @giatien2
END

--Ví dụ nhập vào
--Example
exec tracuugia @giatien1 = 300000,  @giatien2=400000