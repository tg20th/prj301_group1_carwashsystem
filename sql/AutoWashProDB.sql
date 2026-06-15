USE master;
GO

-- 1. DROP EXISTING DATABASE TO RESET CLEANLY
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'AutoWashProDB')
BEGIN
    ALTER DATABASE AutoWashProDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE AutoWashProDB;
END
GO

-- 2. CREATE DATABASE
CREATE DATABASE AutoWashProDB;
GO

USE AutoWashProDB;
GO

-- =====================================================
-- 1. ROLES
-- =====================================================
CREATE TABLE Roles (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE
);

-- =====================================================
-- 2. ACCOUNTS (UPDATED WITH REJECT REASON)
-- =====================================================
CREATE TABLE Accounts (
    AccountID INT IDENTITY(1,1) PRIMARY KEY,
    RoleID INT NOT NULL,

    Email NVARCHAR(100) NOT NULL UNIQUE,
    Phone NVARCHAR(20) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL,

    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,

    Status NVARCHAR(30) NOT NULL DEFAULT 'Pending',
    RejectReason NVARCHAR(255) NULL, -- Thêm vào đây: Lưu lý do từ chối (e.g., "Invalid Tax Code", "Spam account")

    LastLoginAt DATETIME NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Accounts_Roles FOREIGN KEY(RoleID) REFERENCES Roles(RoleID),
    CONSTRAINT CK_Accounts_Status CHECK (Status IN ('Pending', 'Active', 'Frozen', 'Rejected'))
);
GO
-- =====================================================
-- 3. LOYALTY TIERS
-- =====================================================
CREATE TABLE LoyaltyTiers (
    TierID INT IDENTITY(1,1) PRIMARY KEY,
    TierName NVARCHAR(50) NOT NULL UNIQUE,

    MinSpend DECIMAL(18,0) NOT NULL,
    PointMultiplier DECIMAL(4,2) NOT NULL,

    BenefitDescription NVARCHAR(255),
    IsActive BIT NOT NULL DEFAULT 1
);

-- =====================================================
-- 4. CUSTOMERS
-- =====================================================
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    AccountID INT NOT NULL UNIQUE,
    TierID INT NOT NULL,

    JoinedAt DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Customers_Accounts FOREIGN KEY(AccountID) REFERENCES Accounts(AccountID),
    CONSTRAINT FK_Customers_Tiers FOREIGN KEY(TierID) REFERENCES LoyaltyTiers(TierID)
);

-- =====================================================
-- 5. BUSINESS CUSTOMERS
-- =====================================================
CREATE TABLE BusinessCustomers (
    CustomerID INT PRIMARY KEY,
    CompanyName NVARCHAR(150) NOT NULL,
    TaxCode NVARCHAR(50) NOT NULL UNIQUE,
    CompanyAddress NVARCHAR(255),

    CONSTRAINT FK_BusinessCustomers_Customers FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID)
);
GO

-- =====================================================
-- 6. VEHICLE BRANDS
-- =====================================================
CREATE TABLE VehicleBrands (
    BrandID INT IDENTITY(1,1) PRIMARY KEY,
    BrandName NVARCHAR(50) NOT NULL UNIQUE,
    Country NVARCHAR(50),
    IsActive BIT NOT NULL DEFAULT 1
);

-- =====================================================
-- 7. VEHICLE TYPES
-- =====================================================
CREATE TABLE VehicleTypes (
    VehicleTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255),
    IsActive BIT NOT NULL DEFAULT 1
);

-- =====================================================
-- 8. VEHICLE MODELS
-- =====================================================
CREATE TABLE VehicleModels (
    ModelID INT IDENTITY(1,1) PRIMARY KEY,
    BrandID INT NOT NULL,
    VehicleTypeID INT NOT NULL,

    ModelName NVARCHAR(100) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,

    CONSTRAINT FK_VehicleModels_Brands FOREIGN KEY(BrandID) REFERENCES VehicleBrands(BrandID),
    CONSTRAINT FK_VehicleModels_Types FOREIGN KEY(VehicleTypeID) REFERENCES VehicleTypes(VehicleTypeID),
    CONSTRAINT UQ_Brand_Model UNIQUE(BrandID, ModelName)
);

-- =====================================================
-- 9. VEHICLES
-- =====================================================
CREATE TABLE Vehicles (
    VehicleID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    ModelID INT NOT NULL,

    LicensePlate NVARCHAR(20) NOT NULL UNIQUE,
    Color NVARCHAR(30) NULL,
    ManufactureYear INT NULL
        CHECK (
            ManufactureYear IS NULL
            OR ManufactureYear BETWEEN 1950 AND YEAR(GETDATE()) + 1
        ),

    ImageURL NVARCHAR(255) NULL,
    Status NVARCHAR(30) NOT NULL DEFAULT 'Pending',
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Vehicles_Customers FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_Vehicles_Models FOREIGN KEY(ModelID) REFERENCES VehicleModels(ModelID),
    CONSTRAINT CK_Vehicles_Status CHECK (Status IN ('Pending', 'Active', 'Frozen', 'Rejected')),
    CONSTRAINT CK_Vehicles_LicensePlate CHECK (LicensePlate LIKE '[0-9][0-9][A-Z]-[0-9][0-9][0-9][0-9][0-9]')
);

CREATE INDEX IX_Vehicles_LicensePlate ON Vehicles(LicensePlate);
CREATE INDEX IX_Vehicles_CustomerID ON Vehicles(CustomerID);
CREATE INDEX IX_Vehicles_Status ON Vehicles(Status);
GO

-- =====================================================
-- 10. SERVICES
-- =====================================================
CREATE TABLE Services (
    ServiceID INT IDENTITY(1,1) PRIMARY KEY,
    ServiceName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(255),
    IsActive BIT NOT NULL DEFAULT 1
);

-- =====================================================
-- 11. SERVICE PRICES
-- =====================================================
CREATE TABLE ServicePrices (
    ServiceID INT NOT NULL,
    VehicleTypeID INT NOT NULL,

    Price DECIMAL(18,0) NOT NULL,
    DurationMinutes INT NOT NULL,

    PRIMARY KEY(ServiceID, VehicleTypeID),

    CONSTRAINT FK_ServicePrices_Services FOREIGN KEY(ServiceID) REFERENCES Services(ServiceID),
    CONSTRAINT FK_ServicePrices_VehicleTypes FOREIGN KEY(VehicleTypeID) REFERENCES VehicleTypes(VehicleTypeID)
);

-- =====================================================
-- 12. WASH BAYS
-- =====================================================
CREATE TABLE WashBays (
    WashBayID INT IDENTITY(1,1) PRIMARY KEY,
    BayName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255),
    IsActive BIT NOT NULL DEFAULT 1
);

-- =====================================================
-- 12.5. TIME SLOTS
-- =====================================================
CREATE TABLE TimeSlots (
    TimeSlotID INT IDENTITY(1,1) PRIMARY KEY,
    StartTime DATETIME NOT NULL,
    EndTime DATETIME NOT NULL,
    IsAvailable BIT NOT NULL DEFAULT 1
);
GO

-- =====================================================
-- 13. PROMOTIONS
-- =====================================================
CREATE TABLE Promotions (
    PromotionID INT IDENTITY(1,1) PRIMARY KEY,
    PromoCode NVARCHAR(50) UNIQUE NULL,
    PromotionName NVARCHAR(100) NOT NULL,

    TargetType NVARCHAR(20) NOT NULL DEFAULT 'All', -- 'All', 'Tier', 'Customer'

    DiscountPercent INT NULL,
    DiscountAmount DECIMAL(18,0) NULL,

    StartDate DATE,
    EndDate DATE,
    Description NVARCHAR(255),
    IsActive BIT NOT NULL DEFAULT 1,

    CONSTRAINT CK_Promotion_Discount CHECK (
        (DiscountPercent IS NOT NULL AND DiscountAmount IS NULL)
        OR
        (DiscountPercent IS NULL AND DiscountAmount IS NOT NULL)
    ),
    CONSTRAINT CK_Promotion_Target CHECK (TargetType IN ('All', 'Tier', 'Customer'))
);

-- =====================================================
-- 13.1. PROMOTION TIERS
-- =====================================================
CREATE TABLE PromotionTiers (
    PromotionID INT NOT NULL,
    TierID INT NOT NULL,
    PRIMARY KEY(PromotionID, TierID),
    CONSTRAINT FK_PromoTiers_Promo FOREIGN KEY(PromotionID) REFERENCES Promotions(PromotionID) ON DELETE CASCADE,
    CONSTRAINT FK_PromoTiers_Tier FOREIGN KEY(TierID) REFERENCES LoyaltyTiers(TierID)
);

-- =====================================================
-- 13.2. PROMOTION CUSTOMERS
-- =====================================================
CREATE TABLE PromotionCustomers (
    PromotionID INT NOT NULL,
    CustomerID INT NOT NULL,
    PRIMARY KEY(PromotionID, CustomerID),
    CONSTRAINT FK_PromoCust_Promo FOREIGN KEY(PromotionID) REFERENCES Promotions(PromotionID) ON DELETE CASCADE,
    CONSTRAINT FK_PromoCust_Cust FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID)
);

-- =====================================================
-- 14. REWARDS
-- =====================================================
CREATE TABLE Rewards (
    RewardID INT IDENTITY(1,1) PRIMARY KEY,
    RewardName NVARCHAR(100) NOT NULL UNIQUE,
    RewardType NVARCHAR(30) NOT NULL,
    PointsRequired INT NOT NULL,

    DiscountPercent INT NULL,
    DiscountAmount DECIMAL(18,0) NULL,

    StockQuantity INT NOT NULL DEFAULT 0,
    ExpiryDays INT NULL,
    IsActive BIT NOT NULL DEFAULT 1,

    CONSTRAINT CK_Rewards_Type CHECK (RewardType IN ('Voucher', 'Gift')),
    CONSTRAINT CK_Reward_Discount CHECK (
        (RewardType = 'Gift' AND DiscountPercent IS NULL AND DiscountAmount IS NULL)
        OR
        (RewardType = 'Voucher' AND (
            (DiscountPercent IS NOT NULL AND DiscountAmount IS NULL)
            OR
            (DiscountPercent IS NULL AND DiscountAmount IS NOT NULL)
        ))
    )
);

-- =====================================================
-- 15. POINT TRANSACTIONS
-- =====================================================
CREATE TABLE PointTransactions (
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    InvoiceID INT NULL, 

    PointChange INT NOT NULL,
    TransactionType NVARCHAR(30) NOT NULL,
    TransactionDate DATETIME NOT NULL DEFAULT GETDATE(),
    ExpireDate DATETIME NULL,
    Note NVARCHAR(255),

    CONSTRAINT FK_PointTransactions_Customers FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT CK_PointTransactions_Type CHECK (TransactionType IN ('Earn', 'Redeem', 'Expire', 'Adjust'))
);

-- =====================================================
-- 16. CUSTOMER REWARDS
-- =====================================================
CREATE TABLE CustomerRewards (
    CustomerRewardID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    RewardID INT NOT NULL,

    RedeemedAt DATETIME NOT NULL DEFAULT GETDATE(),
    Status NVARCHAR(30) NOT NULL DEFAULT 'Available',
    UsedAt DATETIME NULL,

    CONSTRAINT FK_CustomerRewards_Customers FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_CustomerRewards_Rewards FOREIGN KEY(RewardID) REFERENCES Rewards(RewardID)
);

-- =====================================================
-- 17. INVOICES
-- =====================================================
CREATE TABLE Invoices (
    InvoiceID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    PromotionID INT NULL,
    CustomerRewardID INT NULL,

    InvoiceDate DATETIME NOT NULL DEFAULT GETDATE(),
    PaymentMethod NVARCHAR(30) NULL,

    SubTotal DECIMAL(18,0) NOT NULL,
    DiscountAmount DECIMAL(18,0) NOT NULL DEFAULT 0,
    FinalAmount DECIMAL(18,0) NOT NULL,
    PaymentStatus NVARCHAR(30) NOT NULL DEFAULT 'Unpaid',
    Note NVARCHAR(255),

    CONSTRAINT FK_Invoices_Customers FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_Invoices_Promotions FOREIGN KEY(PromotionID) REFERENCES Promotions(PromotionID),
    CONSTRAINT FK_Invoices_CustomerRewards FOREIGN KEY(CustomerRewardID) REFERENCES CustomerRewards(CustomerRewardID),
    CONSTRAINT CK_Invoices_Payment CHECK (PaymentMethod IN ('Cash', 'BankTransfer', 'Momo', 'ZaloPay', 'CreditCard') OR PaymentMethod IS NULL),
    CONSTRAINT CK_Invoices_PayStatus CHECK (PaymentStatus IN ('Unpaid', 'Paid', 'Refunded', 'Cancelled'))
);
GO

-- =====================================================
-- FK POINT TRANSACTION -> INVOICE LINKING
-- =====================================================
ALTER TABLE PointTransactions
ADD CONSTRAINT FK_PointTransactions_Invoices
FOREIGN KEY (InvoiceID) REFERENCES Invoices(InvoiceID);
GO

-- =====================================================
-- 18. BOOKINGS
-- =====================================================
CREATE TABLE Bookings (
    BookingID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    VehicleID INT NOT NULL,
    ServiceID INT NOT NULL,           
    WashBayID INT NULL,
    TimeSlotID INT NULL,              
    InvoiceID INT NULL,               

    Quantity INT NOT NULL DEFAULT 1,
    PriceAtOrder DECIMAL(18,0) NOT NULL,
    DurationAtOrder INT NOT NULL,

    BookingDate DATETIME NOT NULL DEFAULT GETDATE(),
    Status NVARCHAR(30) NOT NULL DEFAULT 'Pending',
    Notes NVARCHAR(255),

    CONSTRAINT FK_Bookings_Customers FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_Bookings_Vehicles FOREIGN KEY(VehicleID) REFERENCES Vehicles(VehicleID),
    CONSTRAINT FK_Bookings_Services FOREIGN KEY(ServiceID) REFERENCES Services(ServiceID),
    CONSTRAINT FK_Bookings_WashBays FOREIGN KEY(WashBayID) REFERENCES WashBays(WashBayID),
    CONSTRAINT FK_Bookings_TimeSlots FOREIGN KEY(TimeSlotID) REFERENCES TimeSlots(TimeSlotID),
    CONSTRAINT FK_Bookings_Invoices FOREIGN KEY(InvoiceID) REFERENCES Invoices(InvoiceID),
    CONSTRAINT CK_Bookings_Status CHECK (Status IN ('Pending', 'Confirmed', 'InProgress', 'Completed', 'Cancelled', 'NoShow'))
);
GO

-- =====================================================
-- 19. BOOKING DETAILS
-- =====================================================
CREATE TABLE BookingDetails (
    BookingDetailID INT IDENTITY(1,1) PRIMARY KEY,
    BookingID INT NOT NULL,
    ServiceID INT NOT NULL,

    Quantity INT NOT NULL DEFAULT 1,
    PriceAtOrder DECIMAL(18,0) NOT NULL,
    DurationAtOrder INT NOT NULL,

    CONSTRAINT UQ_Booking_Service UNIQUE(BookingID, ServiceID),
    CONSTRAINT FK_BookingDetails_Bookings FOREIGN KEY(BookingID) REFERENCES Bookings(BookingID),
    CONSTRAINT FK_BookingDetails_Services FOREIGN KEY(ServiceID) REFERENCES Services(ServiceID)
);
GO