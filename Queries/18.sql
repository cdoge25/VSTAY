--18. Viết trigger kiểm tra CheckInTime nhập vào phải sau ngày hiện tại
--18. Write a Trigger cheking if the CheckInTime inputted is truly after the present day
create trigger Insert_Check on Booking
for insert
as 
if ((select CheckInTime from Inserted) < getdate())
begin
  print ('CheckInTime ERROR.'); 
  print ('Thoi gian CheckIn không duoc o qua khu.'); 
  print ('Vui long cap nhat lai.')
  rollback tran
end 
