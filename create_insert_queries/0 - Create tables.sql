--Create tables
CREATE TABLE [GUEST_ACCOUNT] (
  [GuestIDCardNumber] varchar (12) not null,
  [UserName] varchar (12) not null,
  [Password] varchar (50) not null,
  [FirstName] nvarchar (50) not null,
  [LastName] nvarchar (50) not null,
  [D.O.B] date not null,
  [PhoneNumber] varchar (15) unique not null,
  [Email] varchar (50) unique not null,
  PRIMARY KEY ([GuestIDCardNumber])
);

CREATE TABLE [OWNER_ACCOUNT] (
  [OwnerIDCardNumber] varchar (12) not null,
  [UserName] varchar (12) not null,
  [Password] varchar (50) not null,
  [FirstName] nvarchar (50) not null,
  [LastName] nvarchar (50) not null,
  [D.O.B] date not null,
  [PhoneNumber] varchar (15) unique not null,
  [Email] varchar (50) unique not null,
  [BankAccountNumber] varchar (20) unique not null,
  PRIMARY KEY ([OwnerIDCardNumber])
);

CREATE TABLE [ACCOMMODATION_TYPE] (
  [AccommodationTypeID] char (2) not null,
  [AccommodationType] nvarchar (50) not null,
  PRIMARY KEY ([AccommodationTypeID])
);

CREATE TABLE [FACILITIES] (
  [FacilityID] varchar (3) not null,
  [FacilityName] nvarchar (50) not null,
  PRIMARY KEY ([FacilityID])
);

CREATE TABLE [ROOM_AMENITIES] (
  [AmenityID] varchar (3) not null,
  [AmenityName] nvarchar (50) not null,
  PRIMARY KEY ([AmenityID])
);

CREATE TABLE [PROVINCE] (
  [ProvinceID] varchar (6) not null,
  [ProvinceName] nvarchar (30) not null,
  PRIMARY KEY ([ProvinceID])
);

CREATE TABLE [CITY/DISTRICT] (
  [City/DistrictID] varchar (6) not null,
  [City/DistrictName] nvarchar (30) not null,
  [ProvinceID] varchar (6) not null,
  PRIMARY KEY ([City/DistrictID]),
  CONSTRAINT [FK_CITYDISTRICT.ProvinceID]
    FOREIGN KEY ([ProvinceID])
      REFERENCES [PROVINCE]([ProvinceID])
);

CREATE TABLE [ACCOMMODATION] (
  [AccommodationID] varchar (12) not null,
  [AccommodationName] varchar (255) null,
  [OwnerIDCardNumber] varchar (12) not null,
  [City/DistrictID] varchar (6) not null,
  [StreetAddress] nvarchar (255) not null,
  [AccommodationTypeID] char (2) not null,
  [NumberOfRooms] int not null,
  [Capacity] int not null,
  [PricePerNight] numeric (10,0) not null,
  PRIMARY KEY ([AccommodationID]),
  CONSTRAINT [FK_ACCOMMODATION.City/DistrictID]
    FOREIGN KEY ([City/DistrictID])
      REFERENCES [CITY/DISTRICT]([City/DistrictID]),
  CONSTRAINT [FK_ACCOMMODATION.OwnerIDCardNumber]
    FOREIGN KEY ([OwnerIDCardNumber])
      REFERENCES [OWNER_ACCOUNT]([OwnerIDCardNumber]),
  CONSTRAINT [FK_ACCOMMODATION.AccommodationTypeID]
    FOREIGN KEY ([AccommodationTypeID])
      REFERENCES [ACCOMMODATION_TYPE]([AccommodationTypeID])
);

CREATE TABLE [FACILITIES_INCLUDED] (
  [AccommodationID] varchar (12) not null,
  [FacilityID] varchar (3) not null,
  PRIMARY KEY ([AccommodationID], [FacilityID]),
  CONSTRAINT [FK_FACILITIES_INCLUDED.FacilityID]
    FOREIGN KEY ([FacilityID])
      REFERENCES [FACILITIES]([FacilityID]),
  CONSTRAINT [FK_FACILITIES_INCLUDED.AccommodationID]
    FOREIGN KEY ([AccommodationID])
      REFERENCES [ACCOMMODATION]([AccommodationID])
);

CREATE TABLE [AMENITIES_INCLUDED] (
  [AccommodationID] varchar (12) not null,
  [AmenityID] varchar (3) not null,
  PRIMARY KEY ([AccommodationID], [AmenityID]),
  CONSTRAINT [FK_AMENITIES_INCLUDED.AmenityID]
    FOREIGN KEY ([AmenityID])
      REFERENCES [ROOM_AMENITIES]([AmenityID]),
  CONSTRAINT [FK_AMENITIES_INCLUDED.AccommodationID]
    FOREIGN KEY ([AccommodationID])
      REFERENCES [ACCOMMODATION]([AccommodationID])
);

CREATE TABLE [VOUCHER/COUPON] (
  [VCCode] varchar (12) not null,
  [DiscountValue] numeric (10,0) not null,
  [DiscountUnit] varchar (4) not null,
  [ValidFrom] datetime not null,
  [ValidTo] datetime not null,
  PRIMARY KEY ([VCCode])
);

CREATE TABLE [BOOKING_STATUS] (
  [BookingStatusID] varchar (2) not null,
  [StatusName] varchar (50) not null,
  PRIMARY KEY ([BookingStatusID])
);

CREATE TABLE [PAYMENT_TYPE] (
  [PaymentTypeID] varchar (2) not null,
  [PaymentType] varchar (50) not null,
  PRIMARY KEY ([PaymentTypeID])
);

CREATE TABLE [BOOKING] (
  [BookingID] varchar (12) not null,
  [GuestIDCardNumber] varchar (12) not null,
  [AccommodationID] varchar (12) not null,
  [CheckInTime] datetime not null,
  [CheckOutTime] datetime not null,
  [VCCode] varchar (12) null,
  [BookingStatusID] varchar (2) not null,
  [DateTimeCancel] datetime null,
  PRIMARY KEY ([BookingID]),
  CONSTRAINT [FK_BOOKING.GuestIDCardNumber]
    FOREIGN KEY ([GuestIDCardNumber])
      REFERENCES [GUEST_ACCOUNT]([GuestIDCardNumber]),
  CONSTRAINT [FK_BOOKING.AccommodationID]
    FOREIGN KEY ([AccommodationID])
      REFERENCES [ACCOMMODATION]([AccommodationID]),
  CONSTRAINT [FK_BOOKING.VCCode]
    FOREIGN KEY ([VCCode])
      REFERENCES [VOUCHER/COUPON]([VCCode]),
  CONSTRAINT [FK_BOOKING.BookingStatusID]
    FOREIGN KEY ([BookingStatusID])
      REFERENCES [BOOKING_STATUS]([BookingStatusID])
);

CREATE TABLE [PAYMENT] (
  [TransactionID] varchar (14) not null,
  [BookingID] varchar (12) not null,
  [PaymentTypeID] varchar (2) not null,
  [BankAccountNumber] varchar (20) not null,
  PRIMARY KEY ([TransactionID]),
  CONSTRAINT [FK_BOOKING.BookingID]
    FOREIGN KEY ([BookingID])
      REFERENCES [BOOKING]([BookingID]),
  CONSTRAINT [FK_PAYMENT_TYPE.PaymentTypeID]
    FOREIGN KEY ([PaymentTypeID])
      REFERENCES [PAYMENT_TYPE]([PaymentTypeID])
);

CREATE TABLE [FEEDBACK] (
  [GuestIDCardNumber] varchar (12) not null,
  [AccommodationID] varchar (12) not null,
  [Rating] int not null,
  [Comment] nvarchar (100) null,
  PRIMARY KEY ([GuestIDCardNumber], [AccommodationID]),
  CONSTRAINT [FK_FEEDBACK.AccommodationID]
    FOREIGN KEY ([AccommodationID])
      REFERENCES [ACCOMMODATION]([AccommodationID]),
  CONSTRAINT [FK_FEEDBACK.GuestIDCardNumber]
    FOREIGN KEY ([GuestIDCardNumber])
      REFERENCES [GUEST_ACCOUNT]([GuestIDCardNumber])
);
