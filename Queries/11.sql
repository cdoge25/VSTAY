--11. Hiển thị giá thuê mỗi đêm trung bình và tổng số lượng chỗ ở theo từng loại chỗ ở có địa chỉ tại tỉnh “Bình Dương”. Làm tròn số tiền 1 đơn vị. 
--11. Show Average Price per night and number of accommodations categorized by Accommodation type in Binh Duong province, round by 1 decimal.
SELECT acc.accommodationtypeid as [Mã loại hình], acct.accommodationtype as [Loại hình], 
           round(avg(PricePerNight),1) as [Giá Trung Bình Mỗi Đêm], 
           count(acc.accommodationid) as [Số Lượng Căn],
           provincename [Tên tỉnh]
From accommodation acc
Join accommodation_type acct 
On acc.accommodationtypeid = acct.accommodationtypeid 
Join [city/district] c
On acc.[city/districtid] = c.[city/districtid] 
Join province p
On c.provinceid = p.provinceid 
Where p.provincename = N'Bình Dương'
Group by acc.accommodationtypeid, acct.accommodationtype, provincename 
