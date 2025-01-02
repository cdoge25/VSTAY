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
  [FacilityID] varchar (10) not null,
  [FacilityName] nvarchar (50) not null,
  PRIMARY KEY ([FacilityID])
);

CREATE TABLE [AMENITIES] (
  [AmenityID] varchar (10) not null,
  [AmenityName] nvarchar (50) not null,
  PRIMARY KEY ([AmenityID])
);

CREATE TABLE [PROVINCE] (
  [ProvinceID] int not null,
  [ProvinceName] nvarchar (30) not null,
  PRIMARY KEY ([ProvinceID])
);

CREATE TABLE [CITY_DISTRICT] (
  [CityDistrictID] int not null,
  [CityDistrictName] nvarchar (30) not null,
  [ProvinceID] int not null,
  PRIMARY KEY ([CityDistrictID]),
  CONSTRAINT [FK_CITYDISTRICT.ProvinceID]
    FOREIGN KEY ([ProvinceID])
      REFERENCES [PROVINCE]([ProvinceID])
);

CREATE TABLE [ACCOMMODATION] (
  [AccommodationID] varchar (12) not null,
  [AccommodationName] varchar (255) null,
  [OwnerIDCardNumber] varchar (12) not null,
  [CityDistrictID] int not null,
  [StreetAddress] nvarchar (255) not null,
  [AccommodationTypeID] char (2) not null,
  [NumberOfRooms] int not null,
  [Capacity] int not null,
  [PricePerNight] numeric (10,0) not null,
  PRIMARY KEY ([AccommodationID]),
  CONSTRAINT [FK_ACCOMMODATION.CityDistrictID]
    FOREIGN KEY ([CityDistrictID])
      REFERENCES [CITY_DISTRICT]([CityDistrictID]),
  CONSTRAINT [FK_ACCOMMODATION.OwnerIDCardNumber]
    FOREIGN KEY ([OwnerIDCardNumber])
      REFERENCES [OWNER_ACCOUNT]([OwnerIDCardNumber]),
  CONSTRAINT [FK_ACCOMMODATION.AccommodationTypeID]
    FOREIGN KEY ([AccommodationTypeID])
      REFERENCES [ACCOMMODATION_TYPE]([AccommodationTypeID])
);

CREATE TABLE [FACILITIES_INCLUDED] (
  [AccommodationID] varchar (12) not null,
  [FacilityID] varchar (10) not null,
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
  [AmenityID] varchar (10) not null,
  PRIMARY KEY ([AccommodationID], [AmenityID]),
  CONSTRAINT [FK_AMENITIES_INCLUDED.AmenityID]
    FOREIGN KEY ([AmenityID])
      REFERENCES [AMENITIES]([AmenityID]),
  CONSTRAINT [FK_AMENITIES_INCLUDED.AccommodationID]
    FOREIGN KEY ([AccommodationID])
      REFERENCES [ACCOMMODATION]([AccommodationID])
);

CREATE TABLE [VOUCHER_COUPON] (
  [VCCode] varchar (12) not null,
  [DiscountValue] numeric (10,0) not null,
  [DiscountUnit] varchar (4) not null,
  [ValidFrom] datetime not null,
  [ValidTo] datetime not null,
  PRIMARY KEY ([VCCode])
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
  [ReservedCheckInTime] datetime not null,
  [CheckInTime] datetime null,
  [CheckOutTime] datetime null,
  [VCCode] varchar (12) null,
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
      REFERENCES [VOUCHER_COUPON]([VCCode]),
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
  [Rating] varchar (5) not null,
  [Comment] varchar (255) null,
  PRIMARY KEY ([GuestIDCardNumber], [AccommodationID]),
  CONSTRAINT [FK_FEEDBACK.AccommodationID]
    FOREIGN KEY ([AccommodationID])
      REFERENCES [ACCOMMODATION]([AccommodationID]),
  CONSTRAINT [FK_FEEDBACK.GuestIDCardNumber]
    FOREIGN KEY ([GuestIDCardNumber])
      REFERENCES [GUEST_ACCOUNT]([GuestIDCardNumber])
);
