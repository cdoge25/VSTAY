CREATE TABLE "AccommodationPriceHistory" (
    "HistoryID" SERIAL PRIMARY KEY,
    "AccommodationID" character varying(12) NOT NULL,
    "OldPrice" decimal(10,2) NOT NULL,
    "NewPrice" decimal(10,2) NOT NULL,
    "ChangeDate" timestamp DEFAULT CURRENT_TIMESTAMP,
    "ChangedBy" character varying(50) NOT NULL,
    FOREIGN KEY ("AccommodationID") REFERENCES "ACCOMMODATION"("AccommodationID")
);

CREATE OR REPLACE FUNCTION trg_accommodation_price_change()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW."PricePerNight" <> OLD."PricePerNight" THEN
        INSERT INTO "AccommodationPriceHistory" (
            "AccommodationID",
            "OldPrice",
            "NewPrice",
            "ChangedBy"
        ) VALUES (
            NEW."AccommodationID",
            OLD."PricePerNight",
            NEW."PricePerNight",
            current_user
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_accommodation_price_change
AFTER UPDATE ON "ACCOMMODATION"
FOR EACH ROW
EXECUTE FUNCTION trg_accommodation_price_change(); 