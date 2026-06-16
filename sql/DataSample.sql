USE AutoWashProDB;
GO

-- =========================================================================
-- [XÓA DỮ LIỆU CŨ THEO TRÌNH TỰ KHÓA NGOẠI]
-- =========================================================================
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'BookingDetails') DELETE FROM BookingDetails;
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

-- =====================================================
-- 1. ROLES
-- ÉP ID BẰNG IDENTITY_INSERT ĐỂ ĐẢM BẢO CHUẨN 100%
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
INSERT INTO LoyaltyTiers (TierID, TierName, MinSpend, PointMultiplier, BenefitDescription, IsActive) VALUES 
(1, 'Member', 0, 1.00, 'Basic member with standard points earning', 1),
(2, 'Silver', 5000000, 1.25, '5% discount on services and faster processing', 1),
(3, 'Gold', 15000000, 1.50, '10% discount, priority booking and free wax', 1),
(4, 'Platinum', 30000000, 2.00, '15% discount, VIP bays and complimentary detailing', 1);
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
-- 6, 7, 8. VEHICLE METADATA 
-- =====================================================
SET IDENTITY_INSERT VehicleBrands ON;
INSERT INTO VehicleBrands (BrandID, BrandName, Country, IsActive) VALUES (1, 'Toyota', 'Japan', 1), (2, 'Honda', 'Japan', 1), (3, 'Ford', 'USA', 1);
SET IDENTITY_INSERT VehicleBrands OFF;

SET IDENTITY_INSERT VehicleTypes ON;
INSERT INTO VehicleTypes (VehicleTypeID, TypeName, Description, IsActive) VALUES (1, 'Sedan', '4-door passenger car', 1), (2, 'SUV', 'Sport Utility Vehicle', 1);
SET IDENTITY_INSERT VehicleTypes OFF;

SET IDENTITY_INSERT VehicleModels ON;
INSERT INTO VehicleModels (ModelID, BrandID, VehicleTypeID, ModelName, IsActive) VALUES (1, 1, 1, 'Camry', 1), (2, 2, 2, 'CR-V', 1), (3, 3, 2, 'Ranger', 1);
SET IDENTITY_INSERT VehicleModels OFF;
GO

-- =====================================================
-- 9. VEHICLES
-- =====================================================
SET IDENTITY_INSERT Vehicles ON;
INSERT INTO Vehicles (VehicleID, CustomerID, ModelID, LicensePlate, Color, ManufactureYear, Status) VALUES 
(1, 1, 1, '51A-12345', 'White', 2022, 'Active'),
(2, 2, 2, '51B-23456', 'Black', 2021, 'Active'),
(3, 3, 3, '51C-34567', 'Silver', 2023, 'Active'),
(4, 4, 1, '51D-45678', 'Blue', 2020, 'Active'),
(5, 5, 2, '51E-56789', 'Red', 2022, 'Active'),
(6, 6, 3, '51F-67890', 'Gray', 2019, 'Active'),
(7, 7, 1, '51G-78901', 'White', 2023, 'Active'),
(8, 8, 2, '51H-89012', 'Black', 2021, 'Active'),
(9, 9, 3, '51K-90123', 'Blue', 2022, 'Active'),
(10, 10, 1, '51L-01234', 'Silver', 2020, 'Active');
SET IDENTITY_INSERT Vehicles OFF;
GO

-- =====================================================
-- 10. SERVICES
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
-- 11. SERVICE PRICES
-- =====================================================
INSERT INTO ServicePrices (ServiceID, VehicleTypeID, Price, DurationMinutes) VALUES 
(1,1,150000,30),(1,2,200000,40),
(2,1,250000,45),(2,2,300000,60),
(3,1,800000,120),(3,2,1200000,150),
(4,1,300000,40),(5,1,400000,60),
(6,1,350000,45),(7,2,250000,35),
(8,1,2500000,180),(9,2,450000,50),
(10,1,80000,10);
GO

-- =====================================================
-- 12. WASH BAYS
-- =====================================================
SET IDENTITY_INSERT WashBays ON;
INSERT INTO WashBays (WashBayID, BayName, Description, IsActive) VALUES 
(1, 'Bay A1', 'Standard bay near entrance', 1), (2, 'Bay A2', 'Standard bay', 1),
(3, 'Bay B1', 'Premium detailing bay', 1), (4, 'Bay B2', 'Premium bay with lift', 1),
(5, 'Bay C1', 'Express wash bay', 1), (6, 'Bay C2', 'Express wash bay', 1),
(7, 'Bay VIP1', 'VIP customer bay', 1), (8, 'Bay VIP2', 'VIP customer bay', 1),
(9, 'Bay D1', 'Large vehicle bay', 1), (10, 'Bay D2', 'Electric vehicle compatible bay', 1);
SET IDENTITY_INSERT WashBays OFF;
GO

-- =====================================================
-- 12.5. TIME SLOTS
-- =====================================================
SET IDENTITY_INSERT TimeSlots ON;
INSERT INTO TimeSlots (TimeSlotID, StartTime, EndTime, IsAvailable) VALUES
(1, CAST(GETDATE() AS DATE), DATEADD(minute, 30, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), 1), 
(2, DATEADD(hour, 8, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), DATEADD(minute, 510, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), 0), 
(3, DATEADD(hour, 9, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), DATEADD(minute, 570, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), 0), 
(4, DATEADD(hour, 9, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), DATEADD(minute, 600, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), 0), 
(5, DATEADD(hour, 10, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), DATEADD(minute, 630, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), 0), 
(6, DATEADD(hour, 11, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), DATEADD(minute, 690, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), 0), 
(7, DATEADD(hour, 14, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), DATEADD(minute, 870, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), 0), 
(8, DATEADD(hour, 15, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), DATEADD(minute, 930, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), 0); 
SET IDENTITY_INSERT TimeSlots OFF;
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
-- 18. BOOKINGS
-- =====================================================
SET IDENTITY_INSERT Bookings ON;
INSERT INTO Bookings (BookingID, CustomerID, VehicleID, ServiceID, WashBayID, TimeSlotID, InvoiceID, Quantity, PriceAtOrder, DurationAtOrder, BookingDate, Status, Notes) VALUES 
(1, 1, 1, 1, 1, 3, 1, 1, 150000, 30, GETDATE(), 'Completed', 'Exterior wash today'),
(2, 1, 1, 2, 1, 3, 1, 1, 250000, 45, GETDATE(), 'Completed', 'Interior wash today'),
(3, 2, 2, 3, 3, 4, 2, 1, 1200000, 150, GETDATE(), 'Completed', 'Full detailing service'),
(4, 3, 3, 1, 2, 5, 3, 1, 200000, 40, GETDATE(), 'Completed', 'Standard appointment task'),
(5, 4, 4, 8, 4, 6, 4, 1, 2500000, 180, GETDATE(), 'Completed', 'VIP ceramic service'),
(6, 5, 5, 1, 7, 7, 5, 1, 300000, 40, GETDATE(), 'Pending', 'Corporate Fleet Order A'),
(7, 5, 5, 1, 7, 8, 6, 1, 300000, 40, GETDATE(), 'Peding', 'Corporate Fleet Order B'),
(8, 6, 6, 1, 1, 2, NULL, 1, 180000, 35, GETDATE(), 'Pending', 'Awaiting approval');
SET IDENTITY_INSERT Bookings OFF;
GO

-- =====================================================
-- 19. BOOKING DETAILS
-- =====================================================
INSERT INTO BookingDetails (BookingID, ServiceID, Quantity, PriceAtOrder, DurationAtOrder) VALUES 
(1, 1, 1, 150000, 30),
(2, 2, 1, 250000, 45),
(3, 3, 1, 1200000, 150),
(4, 1, 1, 200000, 40),
(5, 8, 1, 2500000, 180),
(6, 1, 1, 300000, 40),
(7, 1, 1, 300000, 40),
(8, 1, 1, 180000, 35);
GO