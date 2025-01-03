-- Create tables
CREATE TABLE `GUEST_ACCOUNT` (
  `GuestIDCardNumber` VARCHAR(12) NOT NULL,
  `UserName` VARCHAR(12) NOT NULL,
  `Password` VARCHAR(50) NOT NULL,
  `FirstName` VARCHAR(50) NOT NULL,
  `LastName` VARCHAR(50) NOT NULL,
  `D.O.B` DATE NOT NULL,
  `PhoneNumber` VARCHAR(15) NOT NULL UNIQUE,
  `Email` VARCHAR(50) NOT NULL UNIQUE,
  PRIMARY KEY (`GuestIDCardNumber`)
);

CREATE TABLE `OWNER_ACCOUNT` (
  `OwnerIDCardNumber` VARCHAR(12) NOT NULL,
  `UserName` VARCHAR(12) NOT NULL,
  `Password` VARCHAR(50) NOT NULL,
  `FirstName` VARCHAR(50) NOT NULL,
  `LastName` VARCHAR(50) NOT NULL,
  `D.O.B` DATE NOT NULL,
  `PhoneNumber` VARCHAR(15) NOT NULL UNIQUE,
  `Email` VARCHAR(50) NOT NULL UNIQUE,
  `BankAccountNumber` VARCHAR(20) NOT NULL UNIQUE,
  PRIMARY KEY (`OwnerIDCardNumber`)
);

CREATE TABLE `ACCOMMODATION_TYPE` (
  `AccommodationTypeID` CHAR(2) NOT NULL,
  `AccommodationType` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`AccommodationTypeID`)
);

CREATE TABLE `FACILITIES` (
  `FacilityID` VARCHAR(10) NOT NULL,
  `FacilityName` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`FacilityID`)
);

CREATE TABLE `AMENITIES` (
  `AmenityID` VARCHAR(10) NOT NULL,
  `AmenityName` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`AmenityID`)
);

CREATE TABLE `PROVINCE` (
  `ProvinceID` INT NOT NULL,
  `ProvinceName` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`ProvinceID`)
);

CREATE TABLE `CITY_DISTRICT` (
  `CityDistrictID` INT NOT NULL,
  `CityDistrictName` VARCHAR(30) NOT NULL,
  `ProvinceID` INT NOT NULL,
  PRIMARY KEY (`CityDistrictID`),
  FOREIGN KEY (`ProvinceID`) REFERENCES `PROVINCE`(`ProvinceID`)
);

CREATE TABLE `ACCOMMODATION` (
  `AccommodationID` VARCHAR(12) NOT NULL,
  `AccommodationName` VARCHAR(255) NULL,
  `OwnerIDCardNumber` VARCHAR(12) NOT NULL,
  `CityDistrictID` INT NOT NULL,
  `StreetAddress` VARCHAR(255) NOT NULL,
  `AccommodationTypeID` CHAR(2) NOT NULL,
  `NumberOfRooms` INT NOT NULL,
  `Capacity` INT NOT NULL,
  `PricePerNight` DECIMAL(10,0) NOT NULL,
  PRIMARY KEY (`AccommodationID`),
  FOREIGN KEY (`CityDistrictID`) REFERENCES `CITY_DISTRICT`(`CityDistrictID`),
  FOREIGN KEY (`OwnerIDCardNumber`) REFERENCES `OWNER_ACCOUNT`(`OwnerIDCardNumber`),
  FOREIGN KEY (`AccommodationTypeID`) REFERENCES `ACCOMMODATION_TYPE`(`AccommodationTypeID`)
);

CREATE TABLE `FACILITIES_INCLUDED` (
  `AccommodationID` VARCHAR(12) NOT NULL,
  `FacilityID` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`AccommodationID`, `FacilityID`),
  FOREIGN KEY (`FacilityID`) REFERENCES `FACILITIES`(`FacilityID`),
  FOREIGN KEY (`AccommodationID`) REFERENCES `ACCOMMODATION`(`AccommodationID`)
);

CREATE TABLE `AMENITIES_INCLUDED` (
  `AccommodationID` VARCHAR(12) NOT NULL,
  `AmenityID` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`AccommodationID`, `AmenityID`),
  FOREIGN KEY (`AmenityID`) REFERENCES `AMENITIES`(`AmenityID`),
  FOREIGN KEY (`AccommodationID`) REFERENCES `ACCOMMODATION`(`AccommodationID`)
);

CREATE TABLE `VOUCHER_COUPON` (
  `VCCode` VARCHAR(12) NOT NULL,
  `DiscountValue` DECIMAL(10,0) NOT NULL,
  `DiscountUnit` VARCHAR(4) NOT NULL,
  `ValidFrom` DATETIME NOT NULL,
  `ValidTo` DATETIME NOT NULL,
  PRIMARY KEY (`VCCode`)
);

CREATE TABLE `BOOKING` (
  `BookingID` VARCHAR(12) NOT NULL,
  `GuestIDCardNumber` VARCHAR(12) NOT NULL,
  `AccommodationID` VARCHAR(12) NOT NULL,
  `ReservedCheckInTime` DATETIME NOT NULL,
  `CheckInTime` DATETIME,
  `CheckOutTime` DATETIME,
  `VCCode` VARCHAR(10),
  `DateTimeCancel` DATETIME,
  PRIMARY KEY (`BookingID`),
  FOREIGN KEY (`GuestIDCardNumber`) REFERENCES `GUEST_ACCOUNT`(`GuestIDCardNumber`),
  FOREIGN KEY (`AccommodationID`) REFERENCES `ACCOMMODATION`(`AccommodationID`),
  FOREIGN KEY (`VCCode`) REFERENCES `VOUCHER_COUPON`(`VCCode`)
);

CREATE TABLE `PAYMENT` (
  `TransactionID` VARCHAR(14) NOT NULL,
  `BookingID` VARCHAR(12) NOT NULL,
  `PaymentType` VARCHAR(12) NOT NULL,
  `BankAccountNumber` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`TransactionID`),
  FOREIGN KEY (`BookingID`) REFERENCES `BOOKING`(`BookingID`)
);

CREATE TABLE `FEEDBACK` (
  `GuestIDCardNumber` VARCHAR(12) NOT NULL,
  `AccommodationID` VARCHAR(12) NOT NULL,
  `Rating` VARCHAR(5) NOT NULL,
  `Comment` VARCHAR(255) NULL,
  PRIMARY KEY (`GuestIDCardNumber`, `AccommodationID`),
  FOREIGN KEY (`AccommodationID`) REFERENCES `ACCOMMODATION`(`AccommodationID`),
  FOREIGN KEY (`GuestIDCardNumber`) REFERENCES `GUEST_ACCOUNT`(`GuestIDCardNumber`)
); 