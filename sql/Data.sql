-- =============================================================================
-- AutoWashPro — Sample Data (BƯỚC 2/2)
-- Chạy SAU AutoWashProDB.sql.
-- Script này TỰ XÓA dữ liệu cũ rồi nạp lại — chạy lại nhiều lần được.
-- DB mới: 1) AutoWashProDB.sql  2) Data.sql
-- DB cũ:  chỉ cần chạy lại Data.sql (tự migrate MaxBookingDaysAhead nếu thiếu).
-- =============================================================================
USE AutoWashProDB;
GO

-- =====================================================
-- 0A. SCHEMA PATCH (DB cũ chưa có cột tier booking)
-- =====================================================
IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('LoyaltyTiers') AND name = 'MaxBookingDaysAhead'
)
BEGIN
    ALTER TABLE LoyaltyTiers ADD MaxBookingDaysAhead INT NOT NULL DEFAULT 3;
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.check_constraints
    WHERE name = 'CK_LoyaltyTiers_MaxBookingDays'
)
BEGIN
    ALTER TABLE LoyaltyTiers ADD CONSTRAINT CK_LoyaltyTiers_MaxBookingDays
        CHECK (MaxBookingDaysAhead BETWEEN 1 AND 90);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('Bookings') AND name = 'PaymentOrderCode')
    ALTER TABLE Bookings ADD PaymentOrderCode BIGINT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('Bookings') AND name = 'PaymentLinkId')
    ALTER TABLE Bookings ADD PaymentLinkId NVARCHAR(64) NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('Bookings') AND name = 'PaymentStatus')
BEGIN
    SET QUOTED_IDENTIFIER ON;
    ALTER TABLE Bookings ADD PaymentStatus NVARCHAR(20) NOT NULL DEFAULT 'Unpaid' WITH VALUES;
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('Bookings') AND name = 'PaymentExpiredAt')
    ALTER TABLE Bookings ADD PaymentExpiredAt DATETIME NULL;
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_Bookings_PaymentStatus')
BEGIN
    ALTER TABLE Bookings ADD CONSTRAINT CK_Bookings_PaymentStatus
        CHECK (PaymentStatus IN ('Unpaid', 'Paid', 'Expired', 'Cancelled'));
END
GO

-- =====================================================
-- 0B. XÓA DỮ LIỆU CŨ (đúng thứ tự khóa ngoại)
-- =====================================================
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'BookingDetails') DELETE FROM BookingDetails;
DELETE FROM Bookings;
DELETE FROM PointTransactions;
DELETE FROM Invoices;
DELETE FROM CustomerRewards;
DELETE FROM Rewards;
DELETE FROM PromotionCustomers;
DELETE FROM PromotionTiers;
DELETE FROM Promotions;
DELETE FROM TimeSlots;
DELETE FROM WashBays;
DELETE FROM ServicePrices;
DELETE FROM Services;
DELETE FROM Vehicles;
DELETE FROM VehicleModels;
DELETE FROM VehicleTypes;
DELETE FROM VehicleBrands;
DELETE FROM BusinessCustomers;
DELETE FROM Customers;
DELETE FROM LoyaltyTiers;
DELETE FROM Accounts;
DELETE FROM Roles;
GO

DBCC CHECKIDENT ('VehicleModels', RESEED, 0);
DBCC CHECKIDENT ('VehicleTypes', RESEED, 0);
DBCC CHECKIDENT ('VehicleBrands', RESEED, 0);
DBCC CHECKIDENT ('TimeSlots', RESEED, 0);
GO

-- =====================================================
-- 1. ROLES
-- =====================================================
SET IDENTITY_INSERT Roles ON;
INSERT INTO Roles (RoleID, RoleName) VALUES
(1, 'Admin'),
(2, 'Customer');
SET IDENTITY_INSERT Roles OFF;
GO

-- =====================================================
-- 2. ACCOUNTS
-- =====================================================
SET IDENTITY_INSERT Accounts ON;
INSERT INTO Accounts (AccountID, RoleID, Email, Phone, Password, FirstName, LastName, Status, RejectReason) VALUES
(1, 1, 'admin@autowashpro.com', '0901234567', 'AdminPass123!', 'John', 'Admin', 'Active', NULL),
(2, 2, 'customer1@gmail.com', '0911123456', 'CustPass101@', 'Michael', 'Johnson', 'Active', NULL),
(3, 2, 'customer2@gmail.com', '0912234567', 'EmmaPass202#', 'Emma', 'Williams', 'Active', NULL),
(4, 2, 'customer3@gmail.com', '0913345678', 'DavidPass303$', 'David', 'Jones', 'Active', NULL),
(5, 2, 'customer4@gmail.com', '0914456789', 'SophiaPass404!', 'Sophia', 'Garcia', 'Active', NULL),
(6, 2, 'business1@company.com', '0921123456', 'BizAdmin505#', 'James', 'Miller', 'Active', NULL),
(7, 2, 'customer5@gmail.com', '0915567890', 'OliviaPass606@', 'Olivia', 'Davis', 'Pending', NULL),
(8, 2, 'customer6@gmail.com', '0916678901', 'LiamPass808!', 'Liam', 'Moore', 'Active', NULL),
(9, 2, 'customer7@gmail.com', '0917789012', 'IsabellaPass909#', 'Isabella', 'Taylor', 'Rejected', N'Invalid Corporate Registration Certificate Number.'),
(10, 2, 'customer8@gmail.com', '0918890123', 'NoahPass1111$', 'Noah', 'Thomas', 'Active', NULL),
(11, 2, 'customer9@gmail.com', '0919901234', 'AvaPass1212!', 'Ava', 'Jackson', 'Active', NULL);
SET IDENTITY_INSERT Accounts OFF;
GO

-- =====================================================
-- 3. LOYALTY TIERS
-- =====================================================
SET IDENTITY_INSERT LoyaltyTiers ON;
INSERT INTO LoyaltyTiers (TierID, TierName, MinSpend, PointMultiplier, BenefitDescription, MaxBookingDaysAhead, IsActive) VALUES
(1, 'Member', 0, 1.00, 'Basic member with standard points earning', 3, 1),
(2, 'Silver', 5000000, 1.25, '5% discount on services and faster processing', 7, 1),
(3, 'Gold', 15000000, 1.50, '10% discount, priority booking and free wax', 14, 1),
(4, 'Platinum', 30000000, 2.00, '15% discount, VIP bays and complimentary detailing', 30, 1);
SET IDENTITY_INSERT LoyaltyTiers OFF;
GO

-- =====================================================
-- 4. CUSTOMERS
-- =====================================================
SET IDENTITY_INSERT Customers ON;
INSERT INTO Customers (CustomerID, AccountID, TierID, JoinedAt) VALUES
(1, 2, 1, '2025-01-15 08:30:00'),
(2, 3, 2, '2025-02-20 10:15:00'),
(3, 4, 1, '2025-03-10 14:45:00'),
(4, 5, 3, '2025-04-05 09:20:00'),
(5, 6, 2, '2025-05-12 11:00:00'),
(6, 7, 1, '2025-06-18 16:30:00'),
(7, 8, 4, '2025-07-22 08:45:00'),
(8, 9, 2, '2025-08-30 13:10:00'),
(9, 10, 3, '2025-09-14 10:25:00'),
(10, 11, 1, '2025-10-05 15:50:00');
SET IDENTITY_INSERT Customers OFF;
GO

-- =====================================================
-- 5. BUSINESS CUSTOMERS
-- =====================================================
INSERT INTO BusinessCustomers (CustomerID, CompanyName, TaxCode, CompanyAddress) VALUES
(5, 'Tech Solutions Ltd', '0101234567', '123 District 1, Ho Chi Minh City'),
(7, 'Logistics Express', '0209876543', '456 District 7, Ho Chi Minh City'),
(8, 'Auto Fleet Management', '0405566778', '101 District 9, Ho Chi Minh City');
GO

-- =====================================================
-- 6. VEHICLE TYPES (6 dòng xe — ID cố định 1-6 cho ServicePrices)
-- =====================================================
SET IDENTITY_INSERT VehicleTypes ON;
INSERT INTO VehicleTypes (VehicleTypeID, TypeName, Description, IsActive) VALUES
(1, 'Sedan', N'Dòng xe Sedan - 4 cửa, gầm thấp', 1),
(2, 'Hatchback', N'Dòng xe HatchBack - đuôi cụt, 5 cửa', 1),
(3, 'SUV', N'Dòng xe SUV – xe thể thao đa dụng', 1),
(4, 'Crossover', N'Dòng xe Crossover (CUV)', 1),
(5, 'MPV', N'Dòng xe MPV / Minivan – xe đa dụng', 1),
(6, 'Coupe', N'Dòng xe Coupe – xe thể thao mui kín', 1);
SET IDENTITY_INSERT VehicleTypes OFF;
DBCC CHECKIDENT ('VehicleTypes', RESEED, 6);
GO

-- =====================================================
-- 7. VEHICLE BRANDS (35 hãng)
-- =====================================================
INSERT INTO VehicleBrands (BrandName, Country, IsActive) VALUES
('Toyota', 'Japan', 1), ('Honda', 'Japan', 1), ('Mazda', 'Japan', 1),
('Hyundai', 'South Korea', 1), ('Kia', 'South Korea', 1),
('Ford', 'USA', 1), ('Chevrolet', 'USA', 1), ('Jeep', 'USA', 1),
('Mitsubishi', 'Japan', 1), ('Suzuki', 'Japan', 1), ('Nissan', 'Japan', 1), ('Subaru', 'Japan', 1),
('Mercedes-Benz', 'Germany', 1), ('BMW', 'Germany', 1), ('Audi', 'Germany', 1),
('Porsche', 'Germany', 1), ('Volkswagen', 'Germany', 1), ('MINI', 'UK', 1),
('Lexus', 'Japan', 1), ('Volvo', 'Sweden', 1), ('Peugeot', 'France', 1), ('Land Rover', 'UK', 1),
('Jaguar', 'UK', 1), ('Alfa Romeo', 'Italy', 1), ('Fiat', 'Italy', 1),
('Maserati', 'Italy', 1), ('Bentley', 'UK', 1), ('Rolls-Royce', 'UK', 1),
('Ferrari', 'Italy', 1), ('Lamborghini', 'Italy', 1), ('Aston Martin', 'UK', 1), ('McLaren', 'UK', 1),
('VinFast', 'Vietnam', 1), ('MG', 'UK/China', 1), ('BYD', 'China', 1);
GO

-- =====================================================
-- 8. VEHICLE MODELS (~200 mẫu)
-- =====================================================
INSERT INTO VehicleModels (BrandID, VehicleTypeID, ModelName, IsActive)
SELECT b.BrandID, t.VehicleTypeID, m.ModelName, 1
FROM (
    VALUES
    -- ==================== SEDAN ====================
    ('Toyota', 'Sedan', 'Vios'), ('Toyota', 'Sedan', 'Camry'), ('Toyota', 'Sedan', 'Corolla Altis'),
    ('Honda', 'Sedan', 'City'), ('Honda', 'Sedan', 'Civic'), ('Honda', 'Sedan', 'Accord'),
    ('Mazda', 'Sedan', 'Mazda2'), ('Mazda', 'Sedan', 'Mazda3'), ('Mazda', 'Sedan', 'Mazda6'),
    ('Hyundai', 'Sedan', 'Accent'), ('Hyundai', 'Sedan', 'Elantra'), ('Hyundai', 'Sedan', 'Sonata'),
    ('Kia', 'Sedan', 'Soluto'), ('Kia', 'Sedan', 'K3'), ('Kia', 'Sedan', 'K5'),
    ('Nissan', 'Sedan', 'Almera'), ('Nissan', 'Sedan', 'Teana'),
    ('Subaru', 'Sedan', 'WRX'), ('Subaru', 'Sedan', 'Legacy'),
    ('Mercedes-Benz', 'Sedan', 'C-Class'), ('Mercedes-Benz', 'Sedan', 'E-Class'), ('Mercedes-Benz', 'Sedan', 'S-Class'), ('Mercedes-Benz', 'Sedan', 'Maybach S-Class'),
    ('BMW', 'Sedan', '3 Series'), ('BMW', 'Sedan', '5 Series'), ('BMW', 'Sedan', '7 Series'),
    ('Audi', 'Sedan', 'A4'), ('Audi', 'Sedan', 'A6'), ('Audi', 'Sedan', 'A8'),
    ('Lexus', 'Sedan', 'IS 300'), ('Lexus', 'Sedan', 'ES 250'), ('Lexus', 'Sedan', 'LS 500'),
    ('Porsche', 'Sedan', 'Panamera'), ('Porsche', 'Sedan', 'Taycan'),
    ('Volvo', 'Sedan', 'S60'), ('Volvo', 'Sedan', 'S90'),
    ('VinFast', 'Sedan', 'Lux A2.0'),
    ('MG', 'Sedan', 'MG5'), ('MG', 'Sedan', 'MG7'),
    ('BYD', 'Sedan', 'Seal'), ('BYD', 'Sedan', 'Han'),
    ('Maserati', 'Sedan', 'Ghibli'), ('Maserati', 'Sedan', 'Quattroporte'),
    ('Bentley', 'Sedan', 'Flying Spur'),
    ('Rolls-Royce', 'Sedan', 'Ghost'), ('Rolls-Royce', 'Sedan', 'Phantom'),
    ('Jaguar', 'Sedan', 'XE'), ('Jaguar', 'Sedan', 'XF'),
    ('Alfa Romeo', 'Sedan', 'Giulia'), ('Volkswagen', 'Sedan', 'Passat'),

    -- ==================== HATCHBACK ====================
    ('Toyota', 'Hatchback', 'Yaris'), ('Toyota', 'Hatchback', 'Wigo'),
    ('Honda', 'Hatchback', 'Brio'), ('Honda', 'Hatchback', 'Civic Type R'),
    ('Hyundai', 'Hatchback', 'Grand i10'),
    ('Kia', 'Hatchback', 'Morning'),
    ('Mazda', 'Hatchback', 'Mazda2 Sport'), ('Mazda', 'Hatchback', 'Mazda3 Sport'),
    ('Suzuki', 'Hatchback', 'Swift'), ('Suzuki', 'Hatchback', 'Celerio'),
    ('VinFast', 'Hatchback', 'Fadil'),
    ('Mercedes-Benz', 'Hatchback', 'A-Class'),
    ('BMW', 'Hatchback', '1 Series'),
    ('Audi', 'Hatchback', 'A1'), ('Audi', 'Hatchback', 'A3 Sportback'),
    ('MINI', 'Hatchback', 'Cooper 3-Door'), ('MINI', 'Hatchback', 'Cooper 5-Door'),
    ('Volkswagen', 'Hatchback', 'Golf'), ('Volkswagen', 'Hatchback', 'Polo'),
    ('Peugeot', 'Hatchback', '208'), ('Peugeot', 'Hatchback', '308'),
    ('BYD', 'Hatchback', 'Dolphin'),
    ('Fiat', 'Hatchback', '500'),

    -- ==================== CUV (CROSSOVER) ====================
    ('Toyota', 'Crossover', 'Corolla Cross'), ('Toyota', 'Crossover', 'Yaris Cross'), ('Toyota', 'Crossover', 'Raize'),
    ('Honda', 'Crossover', 'CR-V'), ('Honda', 'Crossover', 'HR-V'),
    ('Mazda', 'Crossover', 'CX-3'), ('Mazda', 'Crossover', 'CX-30'), ('Mazda', 'Crossover', 'CX-5'),
    ('Hyundai', 'Crossover', 'Tucson'), ('Hyundai', 'Crossover', 'Creta'), ('Hyundai', 'Crossover', 'Venue'),
    ('Kia', 'Crossover', 'Sportage'), ('Kia', 'Crossover', 'Seltos'), ('Kia', 'Crossover', 'Sonet'),
    ('Ford', 'Crossover', 'Territory'),
    ('Mitsubishi', 'Crossover', 'Xforce'), ('Mitsubishi', 'Crossover', 'Outlander'),
    ('Nissan', 'Crossover', 'Kicks'), ('Nissan', 'Crossover', 'X-Trail'),
    ('Subaru', 'Crossover', 'Forester'), ('Subaru', 'Crossover', 'Outback'), ('Subaru', 'Crossover', 'Crosstrek'),
    ('Peugeot', 'Crossover', '2008'), ('Peugeot', 'Crossover', '3008'), ('Peugeot', 'Crossover', '408'),
    ('Volvo', 'Crossover', 'XC40'), ('Volvo', 'Crossover', 'XC60'),
    ('Mercedes-Benz', 'Crossover', 'GLA'), ('Mercedes-Benz', 'Crossover', 'GLB'), ('Mercedes-Benz', 'Crossover', 'GLC'),
    ('BMW', 'Crossover', 'X1'), ('BMW', 'Crossover', 'X2'), ('BMW', 'Crossover', 'X3'), ('BMW', 'Crossover', 'X4'),
    ('Audi', 'Crossover', 'Q2'), ('Audi', 'Crossover', 'Q3'), ('Audi', 'Crossover', 'Q5'),
    ('Lexus', 'Crossover', 'UX 250h'), ('Lexus', 'Crossover', 'NX 300'), ('Lexus', 'Crossover', 'RX 350'),
    ('Porsche', 'Crossover', 'Macan'),
    ('VinFast', 'Crossover', 'VF e34'), ('VinFast', 'Crossover', 'VF 5'), ('VinFast', 'Crossover', 'VF 6'), ('VinFast', 'Crossover', 'VF 7'),
    ('MG', 'Crossover', 'MG ZS'), ('MG', 'Crossover', 'MG HS'), ('MG', 'Crossover', 'MG RX5'),
    ('BYD', 'Crossover', 'Atto 3'),
    ('Jaguar', 'Crossover', 'E-Pace'), ('Jaguar', 'Crossover', 'F-Pace'),
    ('Alfa Romeo', 'Crossover', 'Stelvio'), ('Volkswagen', 'Crossover', 'Tiguan'), ('Volkswagen', 'Crossover', 'T-Cross'),

    -- ==================== SUV ====================
    ('Toyota', 'SUV', 'Fortuner'), ('Toyota', 'SUV', 'Land Cruiser'), ('Toyota', 'SUV', 'Land Cruiser Prado'),
    ('Hyundai', 'SUV', 'Santa Fe'), ('Hyundai', 'SUV', 'Palisade'),
    ('Kia', 'SUV', 'Sorento'), ('Kia', 'SUV', 'Telluride'),
    ('Ford', 'SUV', 'Everest'), ('Ford', 'SUV', 'Explorer'),
    ('Mazda', 'SUV', 'CX-8'), ('Mazda', 'SUV', 'CX-9'),
    ('Mitsubishi', 'SUV', 'Pajero Sport'),
    ('Chevrolet', 'SUV', 'Trailblazer'), ('Chevrolet', 'SUV', 'Tahoe'),
    ('Jeep', 'SUV', 'Wrangler'), ('Jeep', 'SUV', 'Grand Cherokee'),
    ('Mercedes-Benz', 'SUV', 'GLE'), ('Mercedes-Benz', 'SUV', 'GLS'), ('Mercedes-Benz', 'SUV', 'G-Class'),
    ('BMW', 'SUV', 'X5'), ('BMW', 'SUV', 'X6'), ('BMW', 'SUV', 'X7'),
    ('Audi', 'SUV', 'Q7'), ('Audi', 'SUV', 'Q8'),
    ('Lexus', 'SUV', 'GX 460'), ('Lexus', 'SUV', 'LX 600'),
    ('Porsche', 'SUV', 'Cayenne'),
    ('Volvo', 'SUV', 'XC90'),
    ('Land Rover', 'SUV', 'Range Rover'), ('Land Rover', 'SUV', 'Range Rover Sport'), ('Land Rover', 'SUV', 'Defender'), ('Land Rover', 'SUV', 'Discovery'),
    ('VinFast', 'SUV', 'Lux SA2.0'), ('VinFast', 'SUV', 'VF 8'), ('VinFast', 'SUV', 'VF 9'), ('VinFast', 'SUV', 'VF 3'),
    ('Maserati', 'SUV', 'Levante'), ('Maserati', 'SUV', 'Grecale'),
    ('Bentley', 'SUV', 'Bentayga'),
    ('Rolls-Royce', 'SUV', 'Cullinan'),
    ('Lamborghini', 'SUV', 'Urus'),
    ('Aston Martin', 'SUV', 'DBX'),
    ('Volkswagen', 'SUV', 'Teramont'), ('Peugeot', 'SUV', '5008'),

    -- ==================== MPV / MINIVAN ====================
    ('Toyota', 'MPV', 'Innova Cross'), ('Toyota', 'MPV', 'Veloz Cross'), ('Toyota', 'MPV', 'Avanza Premio'), ('Toyota', 'MPV', 'Alphard'), ('Toyota', 'MPV', 'Sienna'),
    ('Mitsubishi', 'MPV', 'Xpander'), ('Mitsubishi', 'MPV', 'Xpander Cross'),
    ('Kia', 'MPV', 'Carnival'), ('Kia', 'MPV', 'Carens'),
    ('Hyundai', 'MPV', 'Stargazer'), ('Hyundai', 'MPV', 'Custin'), ('Hyundai', 'MPV', 'Staria'),
    ('Suzuki', 'MPV', 'XL7'), ('Suzuki', 'MPV', 'Ertiga'),
    ('Honda', 'MPV', 'BR-V'), ('Honda', 'MPV', 'Odyssey'),
    ('Mercedes-Benz', 'MPV', 'V-Class'),
    ('Volkswagen', 'MPV', 'Viloran'), ('Volkswagen', 'MPV', 'Touran'),

    -- ==================== COUPE (THỂ THAO MUI KÍN) ====================
    ('Toyota', 'Coupe', 'GR86'), ('Toyota', 'Coupe', 'Supra'),
    ('Ford', 'Coupe', 'Mustang'),
    ('Chevrolet', 'Coupe', 'Camaro'), ('Chevrolet', 'Coupe', 'Corvette'),
    ('Porsche', 'Coupe', '911 Carrera'), ('Porsche', 'Coupe', '718 Cayman'),
    ('Mercedes-Benz', 'Coupe', 'CLE Coupe'), ('Mercedes-Benz', 'Coupe', 'AMG GT'),
    ('BMW', 'Coupe', '2 Series Coupe'), ('BMW', 'Coupe', '4 Series Coupe'), ('BMW', 'Coupe', '8 Series Coupe'),
    ('Audi', 'Coupe', 'TT'), ('Audi', 'Coupe', 'R8'),
    ('Lexus', 'Coupe', 'RC 300'), ('Lexus', 'Coupe', 'LC 500'),
    ('Subaru', 'Coupe', 'BRZ'),
    ('Ferrari', 'Coupe', 'F8 Tributo'), ('Ferrari', 'Coupe', 'Roma'), ('Ferrari', 'Coupe', '296 GTB'),
    ('Lamborghini', 'Coupe', 'Huracan'), ('Lamborghini', 'Coupe', 'Aventador'), ('Lamborghini', 'Coupe', 'Revuelto'),
    ('McLaren', 'Coupe', '720S'), ('McLaren', 'Coupe', 'Artura'),
    ('Aston Martin', 'Coupe', 'Vantage'), ('Aston Martin', 'Coupe', 'DB11'), ('Aston Martin', 'Coupe', 'DBS'),
    ('Bentley', 'Coupe', 'Continental GT'),
    ('Maserati', 'Coupe', 'MC20'), ('Maserati', 'Coupe', 'GranTurismo'),
    ('Jaguar', 'Coupe', 'F-Type')

) AS m(BrandName, TypeName, ModelName)
INNER JOIN VehicleBrands b ON b.BrandName = m.BrandName
INNER JOIN VehicleTypes t ON t.TypeName = m.TypeName;
GO

-- =====================================================
-- 9. SERVICES
-- =====================================================
SET IDENTITY_INSERT Services ON;
INSERT INTO Services (ServiceID, ServiceName, Description, IsActive) VALUES
(1, 'Exterior Wash', 'Basic car wash with foam and rinse', 1),
(2, 'Interior Cleaning', 'Vacuum and wipe interior surfaces', 1),
(3, 'Full Detailing', 'Complete interior + exterior detailing', 1),
(4, 'Engine Wash', 'Clean engine bay', 1),
(5, 'Wax & Polish', 'Apply protective wax and polish', 1),
(6, 'Headlight Restoration', 'Restore clarity to headlights', 1),
(7, 'Tire & Wheel Cleaning', 'Deep clean tires and rims', 1),
(8, 'Ceramic Coating', 'Long-term paint protection', 1),
(9, 'Underbody Wash', 'Clean undercarriage', 1),
(10, 'Air Freshener Service', 'Premium scent application', 1);
SET IDENTITY_INSERT Services OFF;
GO

-- =====================================================
-- 10. SERVICE PRICES (6 dòng xe x 10 dịch vụ, 17-23 phút)
-- =====================================================
-- Giá 2.000đ mỗi combo (test payOS / giảm rủi ro chuyển khoản thật)
INSERT INTO ServicePrices (ServiceID, VehicleTypeID, Price, DurationMinutes) VALUES
(1, 1, 2000, 17), (1, 2, 2000, 17), (1, 3, 2000, 17), (1, 4, 2000, 17), (1, 5, 2000, 17), (1, 6, 2000, 17),
(2, 1, 2000, 18), (2, 2, 2000, 18), (2, 3, 2000, 18), (2, 4, 2000, 18), (2, 5, 2000, 18), (2, 6, 2000, 18),
(3, 1, 2000, 23), (3, 2, 2000, 23), (3, 3, 2000, 23), (3, 4, 2000, 23), (3, 5, 2000, 23), (3, 6, 2000, 23),
(4, 1, 2000, 20), (4, 2, 2000, 20), (4, 3, 2000, 20), (4, 4, 2000, 20), (4, 5, 2000, 20), (4, 6, 2000, 20),
(5, 1, 2000, 22), (5, 2, 2000, 22), (5, 3, 2000, 22), (5, 4, 2000, 22), (5, 5, 2000, 22), (5, 6, 2000, 22),
(6, 1, 2000, 19), (6, 2, 2000, 19), (6, 3, 2000, 19), (6, 4, 2000, 19), (6, 5, 2000, 19), (6, 6, 2000, 19),
(7, 1, 2000, 21), (7, 2, 2000, 21), (7, 3, 2000, 21), (7, 4, 2000, 21), (7, 5, 2000, 21), (7, 6, 2000, 21),
(8, 1, 2000, 23), (8, 2, 2000, 23), (8, 3, 2000, 23), (8, 4, 2000, 23), (8, 5, 2000, 23), (8, 6, 2000, 23),
(9, 1, 2000, 20), (9, 2, 2000, 20), (9, 3, 2000, 20), (9, 4, 2000, 20), (9, 5, 2000, 20), (9, 6, 2000, 20),
(10, 1, 2000, 17), (10, 2, 2000, 17), (10, 3, 2000, 17), (10, 4, 2000, 17), (10, 5, 2000, 17), (10, 6, 2000, 17);
GO

-- =====================================================
-- 11. CUSTOMER VEHICLES (10 xe mẫu)
-- =====================================================
INSERT INTO Vehicles (CustomerID, ModelID, LicensePlate, Color, ManufactureYear, Status)
SELECT 1, vm.ModelID, '51A-12345', 'White', 2022, 'Active'
FROM VehicleModels vm INNER JOIN VehicleBrands vb ON vm.BrandID = vb.BrandID
WHERE vb.BrandName = 'Toyota' AND vm.ModelName = 'Camry';

INSERT INTO Vehicles (CustomerID, ModelID, LicensePlate, Color, ManufactureYear, Status)
SELECT 2, vm.ModelID, '51B-23456', 'Black', 2021, 'Active'
FROM VehicleModels vm INNER JOIN VehicleBrands vb ON vm.BrandID = vb.BrandID
WHERE vb.BrandName = 'Honda' AND vm.ModelName = 'CR-V';

INSERT INTO Vehicles (CustomerID, ModelID, LicensePlate, Color, ManufactureYear, Status)
SELECT 3, vm.ModelID, '51C-34567', 'Silver', 2023, 'Active'
FROM VehicleModels vm INNER JOIN VehicleBrands vb ON vm.BrandID = vb.BrandID
WHERE vb.BrandName = 'Ford' AND vm.ModelName = 'Everest';

INSERT INTO Vehicles (CustomerID, ModelID, LicensePlate, Color, ManufactureYear, Status)
SELECT 4, vm.ModelID, '51D-45678', 'Blue', 2020, 'Active'
FROM VehicleModels vm INNER JOIN VehicleBrands vb ON vm.BrandID = vb.BrandID
WHERE vb.BrandName = 'Toyota' AND vm.ModelName = 'Camry';

INSERT INTO Vehicles (CustomerID, ModelID, LicensePlate, Color, ManufactureYear, Status)
SELECT 5, vm.ModelID, '51E-56789', 'Red', 2022, 'Active'
FROM VehicleModels vm INNER JOIN VehicleBrands vb ON vm.BrandID = vb.BrandID
WHERE vb.BrandName = 'Honda' AND vm.ModelName = 'CR-V';

INSERT INTO Vehicles (CustomerID, ModelID, LicensePlate, Color, ManufactureYear, Status)
SELECT 6, vm.ModelID, '51F-67890', 'Gray', 2019, 'Active'
FROM VehicleModels vm INNER JOIN VehicleBrands vb ON vm.BrandID = vb.BrandID
WHERE vb.BrandName = 'Ford' AND vm.ModelName = 'Everest';

INSERT INTO Vehicles (CustomerID, ModelID, LicensePlate, Color, ManufactureYear, Status)
SELECT 7, vm.ModelID, '51G-78901', 'White', 2023, 'Active'
FROM VehicleModels vm INNER JOIN VehicleBrands vb ON vm.BrandID = vb.BrandID
WHERE vb.BrandName = 'Toyota' AND vm.ModelName = 'Camry';

INSERT INTO Vehicles (CustomerID, ModelID, LicensePlate, Color, ManufactureYear, Status)
SELECT 8, vm.ModelID, '51H-89012', 'Black', 2021, 'Active'
FROM VehicleModels vm INNER JOIN VehicleBrands vb ON vm.BrandID = vb.BrandID
WHERE vb.BrandName = 'Honda' AND vm.ModelName = 'CR-V';

INSERT INTO Vehicles (CustomerID, ModelID, LicensePlate, Color, ManufactureYear, Status)
SELECT 9, vm.ModelID, '51K-90123', 'Blue', 2022, 'Active'
FROM VehicleModels vm INNER JOIN VehicleBrands vb ON vm.BrandID = vb.BrandID
WHERE vb.BrandName = 'Ford' AND vm.ModelName = 'Everest';

INSERT INTO Vehicles (CustomerID, ModelID, LicensePlate, Color, ManufactureYear, Status)
SELECT 10, vm.ModelID, '51L-01234', 'Silver', 2020, 'Active'
FROM VehicleModels vm INNER JOIN VehicleBrands vb ON vm.BrandID = vb.BrandID
WHERE vb.BrandName = 'Toyota' AND vm.ModelName = 'Camry';
GO

-- =====================================================
-- 12. WASH BAYS
-- =====================================================
SET IDENTITY_INSERT WashBays ON;
INSERT INTO WashBays (WashBayID, BayName, Description, Status) VALUES
(1, 'Bay A1', 'Standard bay near entrance', 'Available'),
(2, 'Bay A2', 'Standard bay', 'Unavailable'),
(3, 'Bay B1', 'Premium detailing bay', 'Available'),
(4, 'Bay B2', 'Premium bay with lift', 'Maintenance'),
(5, 'Bay C1', 'Express wash bay', 'Available'),
(6, 'Bay C2', 'Express wash bay', 'Available'),
(7, 'Bay VIP1', 'VIP customer bay', 'Unavailable'),
(8, 'Bay VIP2', 'VIP customer bay', 'Available'),
(9, 'Bay D1', 'Large vehicle bay', 'Maintenance'),
(10, 'Bay D2', 'Electric vehicle compatible bay', 'Available');
SET IDENTITY_INSERT WashBays OFF;
GO

-- =====================================================
-- 13. TIME SLOTS — hôm nay + ngày mai (08:00-20:00, 30 phút/slot)
-- =====================================================
;WITH Dates AS (
    SELECT CAST(GETDATE() AS DATE) AS SlotDate
    UNION ALL
    SELECT DATEADD(DAY, 1, CAST(GETDATE() AS DATE))
),
Numbers AS (
    SELECT TOP 24 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS n
    FROM sys.all_objects
)
INSERT INTO TimeSlots (SlotDate, StartTime, EndTime, IsFull)
SELECT
    d.SlotDate,
    DATEADD(MINUTE, n.n * 30, CAST(d.SlotDate AS DATETIME) + CAST('08:00:00' AS DATETIME)),
    DATEADD(MINUTE, (n.n + 1) * 30, CAST(d.SlotDate AS DATETIME) + CAST('08:00:00' AS DATETIME)),
    0
FROM Dates d
CROSS JOIN Numbers n
WHERE DATEADD(MINUTE, (n.n + 1) * 30, CAST(d.SlotDate AS DATETIME) + CAST('08:00:00' AS DATETIME))
      <= CAST(d.SlotDate AS DATETIME) + CAST('20:00:00' AS DATETIME);
GO

-- =====================================================
-- 13. PROMOTIONS
-- =====================================================
SET IDENTITY_INSERT Promotions ON;
INSERT INTO Promotions (PromotionID, PromoCode, PromotionName, TargetType, DiscountPercent, StartDate, EndDate, Description, IsActive) VALUES 
(1, 'SUMMER25', 'Summer Special', 'All', 25, '2026-06-01', '2026-08-31', '25% off all services', 1),
(2, 'FIRST10', 'First Time Discount', 'Customer', 15, '2026-01-01', '2026-12-31', '15% for new customers', 1),
(3, 'GOLDVIP', 'Gold Member Bonus', 'Tier', 20, '2026-01-01', '2026-12-31', 'Extra 20% for Gold tier', 1),
(4, 'FLEET30', 'Business Fleet', 'All', 30, '2026-01-01', '2026-12-31', '30% for business customers', 1),
(5, 'WEEKEND15', 'Weekend Special', 'All', 15, '2026-06-01', '2026-12-31', '15% off on weekends', 1),
(6, 'REFER10', 'Referral Bonus', 'Customer', 10, '2026-01-01', '2026-12-31', '10% for referred customers', 1),
(7, 'PLATINUM50', 'Platinum Exclusive', 'Tier', 50, '2026-05-01', '2026-07-31', '50% off for Platinum', 1),
(8, 'ECO10', 'Eco Friendly', 'All', 10, '2026-06-01', '2026-12-31', '10% for electric vehicles', 1);
SET IDENTITY_INSERT Promotions OFF;
GO

INSERT INTO PromotionTiers (PromotionID, TierID) VALUES (3,3),(3,4),(7,4);
INSERT INTO PromotionCustomers (PromotionID, CustomerID) VALUES (2,1),(2,2),(6,3),(6,4);
GO

-- =====================================================
-- 14. REWARDS
-- =====================================================
SET IDENTITY_INSERT Rewards ON;
INSERT INTO Rewards (RewardID, RewardName, RewardType, PointsRequired, DiscountPercent, DiscountAmount, StockQuantity, ExpiryDays, IsActive) VALUES 
(1, 'Free Exterior Wash', 'Voucher', 500, 100, NULL, 100, 30, 1),
(2, 'Interior Cleaning Voucher', 'Voucher', 800, 100, NULL, 80, 45, 1),
(3, '10% Off Next Service', 'Voucher', 1200, 10, NULL, 150, 60, 1),
(4, 'Free Car Air Freshener', 'Gift', 300, NULL, NULL, 200, 90, 1),
(5, 'Premium Wax Voucher', 'Voucher', 2000, NULL, 500000, 50, 30, 1),
(6, 'Full Detailing Voucher', 'Voucher', 5000, 100, NULL, 30, 30, 1);
SET IDENTITY_INSERT Rewards OFF;
GO

-- =====================================================
-- 15. POINT TRANSACTIONS
-- =====================================================
INSERT INTO PointTransactions (CustomerID, InvoiceID, PointChange, TransactionType, Note) VALUES 
(1, NULL, 250, 'Earn', 'First service points'),
(2, NULL, 450, 'Earn', 'Monthly wash'),
(3, NULL, 1200, 'Earn', 'Full detailing'),
(4, NULL, 600, 'Earn', 'Business fleet wash'),
(5, NULL, 350, 'Earn', 'Regular service'),
(6, NULL, 900, 'Earn', 'VIP service'),
(1, NULL, 800, 'Earn', 'Referral bonus');
GO

-- =====================================================
-- 16. CUSTOMER REWARDS
-- =====================================================
INSERT INTO CustomerRewards (CustomerID, RewardID, Status) VALUES 
(1,1,'Available'), (2,2,'Available'), (3,3,'Available'),
(4,4,'Available'), (5,5,'Available'), (6,6,'Available');
GO

-- =====================================================
-- 17. INVOICES
-- =====================================================
SET IDENTITY_INSERT Invoices ON;
INSERT INTO Invoices (InvoiceID, CustomerID, PromotionID, SubTotal, DiscountAmount, FinalAmount, PaymentStatus, PaymentMethod) VALUES 
(1, 1, 1, 400000, 100000, 300000, 'Paid', 'Cash'),               
(2, 2, NULL, 1200000, 120000, 1080000, 'Paid', 'BankTransfer'),   
(3, 3, 5, 450000, 67500, 382500, 'Paid', 'Momo'),                 
(4, 4, NULL, 2500000, 0, 2500000, 'Paid', 'CreditCard'),          
(5, 5, 4, 300000, 90000, 210000, 'Paid', 'BankTransfer'),         
(6, 5, 4, 300000, 90000, 210000, 'Paid', 'BankTransfer'),         
(7, 6, NULL, 600000, 0, 600000, 'Unpaid', NULL),                  
(8, 7, 8, 900000, 90000, 810000, 'Paid', 'Momo'),                 
(9, 8, NULL, 1800000, 0, 1800000, 'Paid', 'Cash');                
SET IDENTITY_INSERT Invoices OFF;
GO


-- =====================================================
-- 18. BOOKINGS (hôm nay — gắn slot theo giờ thực)
-- =====================================================
DECLARE @Today DATE = CAST(GETDATE() AS DATE);

INSERT INTO Bookings (CustomerID, VehicleID, ServiceID, WashBayID, TimeSlotID, InvoiceID, Quantity, PriceAtOrder, DurationAtOrder, BookingDate, Status, Notes)
SELECT 1, v.VehicleID, 1, 1, t.TimeSlotID, 1, 1, 150000, 17, t.StartTime, 'Completed', 'Exterior wash today'
FROM Vehicles v JOIN TimeSlots t ON t.SlotDate = @Today AND CAST(t.StartTime AS TIME) = '09:00:00'
WHERE v.LicensePlate = '51A-12345';

INSERT INTO Bookings (CustomerID, VehicleID, ServiceID, WashBayID, TimeSlotID, InvoiceID, Quantity, PriceAtOrder, DurationAtOrder, BookingDate, Status, Notes)
SELECT 1, v.VehicleID, 2, 2, t.TimeSlotID, 1, 1, 250000, 18, t.StartTime, 'Completed', 'Interior wash today'
FROM Vehicles v JOIN TimeSlots t ON t.SlotDate = @Today AND CAST(t.StartTime AS TIME) = '09:00:00'
WHERE v.LicensePlate = '51A-12345';

INSERT INTO Bookings (CustomerID, VehicleID, ServiceID, WashBayID, TimeSlotID, InvoiceID, Quantity, PriceAtOrder, DurationAtOrder, BookingDate, Status, Notes)
SELECT 2, v.VehicleID, 3, 3, t.TimeSlotID, 2, 1, 950000, 23, t.StartTime, 'Completed', 'Full detailing service'
FROM Vehicles v JOIN TimeSlots t ON t.SlotDate = @Today AND CAST(t.StartTime AS TIME) = '09:30:00'
WHERE v.LicensePlate = '51B-23456';

INSERT INTO Bookings (CustomerID, VehicleID, ServiceID, WashBayID, TimeSlotID, InvoiceID, Quantity, PriceAtOrder, DurationAtOrder, BookingDate, Status, Notes)
SELECT 3, v.VehicleID, 1, 2, t.TimeSlotID, 3, 1, 200000, 17, t.StartTime, 'Completed', 'Standard appointment task'
FROM Vehicles v JOIN TimeSlots t ON t.SlotDate = @Today AND CAST(t.StartTime AS TIME) = '10:00:00'
WHERE v.LicensePlate = '51C-34567';

INSERT INTO Bookings (CustomerID, VehicleID, ServiceID, WashBayID, TimeSlotID, InvoiceID, Quantity, PriceAtOrder, DurationAtOrder, BookingDate, Status, Notes)
SELECT 4, v.VehicleID, 8, 4, t.TimeSlotID, 4, 1, 2500000, 23, t.StartTime, 'Completed', 'VIP ceramic service'
FROM Vehicles v JOIN TimeSlots t ON t.SlotDate = @Today AND CAST(t.StartTime AS TIME) = '11:00:00'
WHERE v.LicensePlate = '51D-45678';

INSERT INTO Bookings (CustomerID, VehicleID, ServiceID, WashBayID, TimeSlotID, InvoiceID, Quantity, PriceAtOrder, DurationAtOrder, BookingDate, Status, Notes)
SELECT 5, v.VehicleID, 1, 7, t.TimeSlotID, 5, 1, 170000, 17, t.StartTime, 'Pending', 'Corporate Fleet Order A'
FROM Vehicles v JOIN TimeSlots t ON t.SlotDate = @Today AND CAST(t.StartTime AS TIME) = '14:00:00'
WHERE v.LicensePlate = '51E-56789';

INSERT INTO Bookings (CustomerID, VehicleID, ServiceID, WashBayID, TimeSlotID, InvoiceID, Quantity, PriceAtOrder, DurationAtOrder, BookingDate, Status, Notes)
SELECT 5, v.VehicleID, 1, 7, t.TimeSlotID, 6, 1, 170000, 17, t.StartTime, 'Pending', 'Corporate Fleet Order B'
FROM Vehicles v JOIN TimeSlots t ON t.SlotDate = @Today AND CAST(t.StartTime AS TIME) = '15:00:00'
WHERE v.LicensePlate = '51E-56789';

INSERT INTO Bookings (CustomerID, VehicleID, ServiceID, WashBayID, TimeSlotID, InvoiceID, Quantity, PriceAtOrder, DurationAtOrder, BookingDate, Status, Notes)
SELECT 6, v.VehicleID, 1, 1, t.TimeSlotID, NULL, 1, 200000, 17, t.StartTime, 'Pending', 'Awaiting approval'
FROM Vehicles v JOIN TimeSlots t ON t.SlotDate = @Today AND CAST(t.StartTime AS TIME) = '08:00:00'
WHERE v.LicensePlate = '51F-67890';
GO

-- =====================================================
-- 19. BOOKING DETAILS (hôm nay)
-- =====================================================
INSERT INTO BookingDetails (BookingID, ServiceID, Quantity, PriceAtOrder, DurationAtOrder)
SELECT b.BookingID, b.ServiceID, b.Quantity, b.PriceAtOrder, b.DurationAtOrder
FROM Bookings b
WHERE b.Notes IN (
    'Exterior wash today', 'Interior wash today', 'Full detailing service',
    'Standard appointment task', 'VIP ceramic service',
    'Corporate Fleet Order A', 'Corporate Fleet Order B', 'Awaiting approval'
);
GO

-- =====================================================
-- 20. BOOKINGS (ngày mai — mẫu)
-- =====================================================
DECLARE @Tomorrow DATE = DATEADD(DAY, 1, CAST(GETDATE() AS DATE));

INSERT INTO Bookings (CustomerID, VehicleID, ServiceID, WashBayID, TimeSlotID, InvoiceID, Quantity, PriceAtOrder, DurationAtOrder, BookingDate, Status, Notes)
SELECT 1, v.VehicleID, 1, 1, t.TimeSlotID, NULL, 1, 150000, 17, t.StartTime, 'Confirmed', 'Tomorrow booking - Exterior Wash 08:00'
FROM Vehicles v
JOIN TimeSlots t ON t.SlotDate = @Tomorrow AND CAST(t.StartTime AS TIME) = '08:00:00'
WHERE v.LicensePlate = '51A-12345'
  AND NOT EXISTS (
      SELECT 1 FROM Bookings b
      WHERE b.WashBayID = 1 AND b.TimeSlotID = t.TimeSlotID
        AND b.Status NOT IN ('Cancelled', 'NoShow')
  );

INSERT INTO Bookings (CustomerID, VehicleID, ServiceID, WashBayID, TimeSlotID, InvoiceID, Quantity, PriceAtOrder, DurationAtOrder, BookingDate, Status, Notes)
SELECT 2, v.VehicleID, 2, 2, t.TimeSlotID, NULL, 1, 270000, 18, t.StartTime, 'Pending', 'Tomorrow booking - Interior Cleaning 09:00'
FROM Vehicles v
JOIN TimeSlots t ON t.SlotDate = @Tomorrow AND CAST(t.StartTime AS TIME) = '09:00:00'
WHERE v.LicensePlate = '51B-23456'
  AND NOT EXISTS (
      SELECT 1 FROM Bookings b
      WHERE b.WashBayID = 2 AND b.TimeSlotID = t.TimeSlotID
        AND b.Status NOT IN ('Cancelled', 'NoShow')
  );

INSERT INTO BookingDetails (BookingID, ServiceID, Quantity, PriceAtOrder, DurationAtOrder)
SELECT b.BookingID, b.ServiceID, b.Quantity, b.PriceAtOrder, b.DurationAtOrder
FROM Bookings b
WHERE b.Notes LIKE 'Tomorrow booking%'
  AND NOT EXISTS (SELECT 1 FROM BookingDetails d WHERE d.BookingID = b.BookingID);
GO

-- =====================================================
-- 21. ĐỒNG BỘ IsFull CHO TẤT CẢ TIME SLOTS
-- =====================================================
UPDATE ts
SET ts.IsFull = CASE WHEN avail.Remaining = 0 THEN 1 ELSE 0 END
FROM TimeSlots ts
CROSS APPLY (
    SELECT COUNT(*) AS Remaining
    FROM WashBays wb
    WHERE wb.Status = 'Available'
      AND NOT EXISTS (
          SELECT 1 FROM Bookings b
          WHERE b.WashBayID = wb.WashBayID
            AND b.TimeSlotID = ts.TimeSlotID
            AND b.Status NOT IN ('Cancelled', 'NoShow')
      )
) avail;
GO

IF (SELECT COUNT(*) FROM ServicePrices) <> 60
BEGIN
    RAISERROR('Data load incomplete: ServicePrices expected 60 rows (6 vehicle types x 10 services). Re-run Data.sql after fixing errors above.', 16, 1);
    RETURN;
END
GO

PRINT 'AutoWashPro sample data loaded successfully.';
GO
