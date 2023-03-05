--20. Viết thủ tục tăng giá mỗi đêm của chỗ ở với tham số truyền vào là mã chỗ ở và giá tăng thêm
--20. Write a Procedure raising the price of an accommodation with the input being Accommodation ID and Amount raising.
create procedure TANGGIAPHONG
@machoo varchar(12),
@giatang int
as
begin
if exists
(select *
from ACCOMMODATION 
)
update ACCOMMODATION 
set PricePerNight = PricePerNight + @giatang
where AccommodationID like @machoo
else print N' Mã phòng không tồn tại'
end

--Ví dụ nhập vào:
--Example:
TANGGIAPHONG @machoo='A000000010', @giatang=500000