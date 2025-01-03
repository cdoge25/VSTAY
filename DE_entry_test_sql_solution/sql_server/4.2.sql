-- 4.2.
-- Create price history table
CREATE TABLE AccommodationPriceHistory (
HistoryID INT IDENTITY(1,1) PRIMARY KEY,
AccommodationID VARCHAR(12) NOT NULL,
OldPrice DECIMAL(10,2) NOT NULL,
NewPrice DECIMAL(10,2) NOT NULL,
ChangeDate DATETIME DEFAULT GETDATE(),
ChangedBy VARCHAR(50) NOT NULL,
FOREIGN KEY (AccommodationID) REFERENCES ACCOMMODATION(AccommodationID)
);
-- Create trigger to track price changes
CREATE TRIGGER trg_Accommodation_PriceChange
ON ACCOMMODATION
AFTER UPDATE
AS
BEGIN
SET NOCOUNT ON;
-- Only track changes to PricePerNight
IF UPDATE(PricePerNight)
BEGIN
INSERT INTO AccommodationPriceHistory (
AccommodationID,
OldPrice,
NewPrice,
ChangedBy
)
SELECT
i.AccommodationID,
d.PricePerNight,
i.PricePerNight,
SYSTEM_USER
FROM inserted i
INNER JOIN deleted d ON i.AccommodationID = d.AccommodationID
WHERE i.PricePerNight != d.PricePerNight;
END;
END;