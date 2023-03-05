--12. Hiển thị tất cả chỗ ở chung thành phố với chỗ ở có mã 'ACM000000642' 
--12. Show other accommodations that are in the same city as the accommodation with ID 'ACM000000642'
SELECT acca.accommodationid [Mã chỗ ở], 
               acca.accommodationname [Tên chỗ ở], 
               acca.[city/districtid] [Mã quận huyện], [city/districtname] [Tên quận huyện]
FROM accommodation acca
Join accommodation accb
On acca.[city/districtid] = accb.[city/districtid] 
Join [city/district] c
On acca.[city/districtid] = c.[city/districtid] 
Where accb.accommodationid = 'ACM000000642'
