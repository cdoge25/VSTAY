-- Test the price_change procedure and verify the price history
CALL price_change('ACM000000001', 50000);
CALL price_change('ACM000000001', -50000);

-- View the price change history
SELECT * FROM "AccommodationPriceHistory"