-- 4.3.
EXECUTE price_change @accommodationid = 'ACM000000001', @change = 50000;
EXECUTE price_change @accommodationid = 'ACM000000001', @change = -50000;
SELECT * FROM AccommodationPriceHistory;