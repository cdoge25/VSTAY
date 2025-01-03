-- Create tables for PostgreSQL
-- Note: Using double quotes for identifiers and proper PostgreSQL data types

CREATE TABLE "GUEST_ACCOUNT" (
  "GuestIDCardNumber" character varying(12) NOT NULL,
  "UserName" character varying(12) NOT NULL,
  "Password" character varying(50) NOT NULL,
  "FirstName" text NOT NULL,
  "LastName" text NOT NULL,
  "D.O.B" date NOT NULL,
  "PhoneNumber" character varying(15) UNIQUE NOT NULL,
  "Email" character varying(50) UNIQUE NOT NULL,
  PRIMARY KEY ("GuestIDCardNumber")
);

CREATE TABLE "OWNER_ACCOUNT" (
  "OwnerIDCardNumber" character varying(12) NOT NULL,
  "UserName" character varying(12) NOT NULL,
  "Password" character varying(50) NOT NULL,
  "FirstName" text NOT NULL,
  "LastName" text NOT NULL,
  "D.O.B" date NOT NULL,
  "PhoneNumber" character varying(15) UNIQUE NOT NULL,
  "Email" character varying(50) UNIQUE NOT NULL,
  "BankAccountNumber" character varying(20) UNIQUE NOT NULL,
  PRIMARY KEY ("OwnerIDCardNumber")
);

CREATE TABLE "ACCOMMODATION_TYPE" (
  "AccommodationTypeID" character(2) NOT NULL,
  "AccommodationType" text NOT NULL,
  PRIMARY KEY ("AccommodationTypeID")
);

CREATE TABLE "FACILITIES" (
  "FacilityID" character varying(10) NOT NULL,
  "FacilityName" text NOT NULL,
  PRIMARY KEY ("FacilityID")
);

CREATE TABLE "AMENITIES" (
  "AmenityID" character varying(10) NOT NULL,
  "AmenityName" text NOT NULL,
  PRIMARY KEY ("AmenityID")
);

CREATE TABLE "PROVINCE" (
  "ProvinceID" integer NOT NULL,
  "ProvinceName" text NOT NULL,
  PRIMARY KEY ("ProvinceID")
);

CREATE TABLE "CITY_DISTRICT" (
  "CityDistrictID" integer NOT NULL,
  "CityDistrictName" text NOT NULL,
  "ProvinceID" integer NOT NULL,
  PRIMARY KEY ("CityDistrictID"),
  CONSTRAINT "FK_CITYDISTRICT_ProvinceID"
    FOREIGN KEY ("ProvinceID")
      REFERENCES "PROVINCE"("ProvinceID")
);

CREATE TABLE "ACCOMMODATION" (
  "AccommodationID" character varying(12) NOT NULL,
  "AccommodationName" character varying(255),
  "OwnerIDCardNumber" character varying(12) NOT NULL,
  "CityDistrictID" integer NOT NULL,
  "StreetAddress" text NOT NULL,
  "AccommodationTypeID" character(2) NOT NULL,
  "NumberOfRooms" integer NOT NULL,
  "Capacity" integer NOT NULL,
  "PricePerNight" decimal(10,0) NOT NULL,
  PRIMARY KEY ("AccommodationID"),
  CONSTRAINT "FK_ACCOMMODATION_CityDistrictID"
    FOREIGN KEY ("CityDistrictID")
      REFERENCES "CITY_DISTRICT"("CityDistrictID"),
  CONSTRAINT "FK_ACCOMMODATION_OwnerIDCardNumber"
    FOREIGN KEY ("OwnerIDCardNumber")
      REFERENCES "OWNER_ACCOUNT"("OwnerIDCardNumber"),
  CONSTRAINT "FK_ACCOMMODATION_AccommodationTypeID"
    FOREIGN KEY ("AccommodationTypeID")
      REFERENCES "ACCOMMODATION_TYPE"("AccommodationTypeID")
);

CREATE TABLE "FACILITIES_INCLUDED" (
  "AccommodationID" character varying(12) NOT NULL,
  "FacilityID" character varying(10) NOT NULL,
  PRIMARY KEY ("AccommodationID", "FacilityID"),
  CONSTRAINT "FK_FACILITIES_INCLUDED_FacilityID"
    FOREIGN KEY ("FacilityID")
      REFERENCES "FACILITIES"("FacilityID"),
  CONSTRAINT "FK_FACILITIES_INCLUDED_AccommodationID"
    FOREIGN KEY ("AccommodationID")
      REFERENCES "ACCOMMODATION"("AccommodationID")
);

CREATE TABLE "AMENITIES_INCLUDED" (
  "AccommodationID" character varying(12) NOT NULL,
  "AmenityID" character varying(10) NOT NULL,
  PRIMARY KEY ("AccommodationID", "AmenityID"),
  CONSTRAINT "FK_AMENITIES_INCLUDED_AmenityID"
    FOREIGN KEY ("AmenityID")
      REFERENCES "AMENITIES"("AmenityID"),
  CONSTRAINT "FK_AMENITIES_INCLUDED_AccommodationID"
    FOREIGN KEY ("AccommodationID")
      REFERENCES "ACCOMMODATION"("AccommodationID")
);

CREATE TABLE "VOUCHER_COUPON" (
  "VCCode" character varying(12) NOT NULL,
  "DiscountValue" decimal(10,0) NOT NULL,
  "DiscountUnit" character varying(4) NOT NULL,
  "ValidFrom" timestamp NOT NULL,
  "ValidTo" timestamp NOT NULL,
  PRIMARY KEY ("VCCode")
);

CREATE TABLE "BOOKING" (
  "BookingID" character varying(12) NOT NULL,
  "GuestIDCardNumber" character varying(12) NOT NULL,
  "AccommodationID" character varying(12) NOT NULL,
  "ReservedCheckInTime" timestamp NOT NULL,
  "CheckInTime" timestamp,
  "CheckOutTime" timestamp,
  "VCCode" character varying(12),
  "DateTimeCancel" timestamp,
  PRIMARY KEY ("BookingID"),
  CONSTRAINT "FK_BOOKING_GuestIDCardNumber"
    FOREIGN KEY ("GuestIDCardNumber")
      REFERENCES "GUEST_ACCOUNT"("GuestIDCardNumber"),
  CONSTRAINT "FK_BOOKING_AccommodationID"
    FOREIGN KEY ("AccommodationID")
      REFERENCES "ACCOMMODATION"("AccommodationID"),
  CONSTRAINT "FK_BOOKING_VCCode"
    FOREIGN KEY ("VCCode")
      REFERENCES "VOUCHER_COUPON"("VCCode")
);

CREATE TABLE "PAYMENT" (
  "TransactionID" character varying(14) NOT NULL,
  "BookingID" character varying(12) NOT NULL,
  "PaymentType" character varying(12) NOT NULL,
  "BankAccountNumber" character varying(20) NOT NULL,
  PRIMARY KEY ("TransactionID"),
  CONSTRAINT "FK_PAYMENT_BookingID"
    FOREIGN KEY ("BookingID")
      REFERENCES "BOOKING"("BookingID")
);

CREATE TABLE "FEEDBACK" (
  "GuestIDCardNumber" character varying(12) NOT NULL,
  "AccommodationID" character varying(12) NOT NULL,
  "Rating" character varying(5) NOT NULL,
  "Comment" character varying(255),
  PRIMARY KEY ("GuestIDCardNumber", "AccommodationID"),
  CONSTRAINT "FK_FEEDBACK_AccommodationID"
    FOREIGN KEY ("AccommodationID")
      REFERENCES "ACCOMMODATION"("AccommodationID"),
  CONSTRAINT "FK_FEEDBACK_GuestIDCardNumber"
    FOREIGN KEY ("GuestIDCardNumber")
      REFERENCES "GUEST_ACCOUNT"("GuestIDCardNumber")
); 