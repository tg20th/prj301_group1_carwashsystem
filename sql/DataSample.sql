USE AutoWashProDB;
GO

-- =========================================================================
-- [XÓA DỮ LIỆU CŨ THEO TRÌNH TỰ KHÓA NGOẠI ĐỂ KHÔNG BỊ LỖI CONFLICT]
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

-- =========================================================================
-- [RESET IDENTITY VỀ 0 ĐỂ ID BẮT ĐẦU CHÍNH XÁC TỪ 1]
-- =========================================================================
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'BookingDetails') DBCC CHECKIDENT ('BookingDetails', RESEED, 0);
DBCC CHECKIDENT ('Bookings', RESEED, 0);
DBCC CHECKIDENT ('PointTransactions', RESEED, 0);
DBCC CHECKIDENT ('Invoices', RESEED, 0);
DBCC CHECKIDENT ('CustomerRewards', RESEED, 0);
DBCC CHECKIDENT ('Rewards', RESEED, 0);
DBCC CHECKIDENT ('Promotions', RESEED, 0);
DBCC CHECKIDENT ('TimeSlots', RESEED, 0);
DBCC CHECKIDENT ('WashBays', RESEED, 0);
DBCC CHECKIDENT ('Services', RESEED, 0);
DBCC CHECKIDENT ('Vehicles', RESEED, 0);
DBCC CHECKIDENT ('VehicleModels', RESEED, 0);
DBCC CHECKIDENT ('VehicleTypes', RESEED, 0);
DBCC CHECKIDENT ('VehicleBrands', RESEED, 0);
DBCC CHECKIDENT ('Customers', RESEED, 0);
DBCC CHECKIDENT ('Accounts', RESEED, 0);
DBCC CHECKIDENT ('LoyaltyTiers', RESEED, 0);
DBCC CHECKIDENT ('Roles', RESEED, 0);
GO

-- =====================================================
-- 1. ROLES
-- =====================================================
INSERT INTO Roles (RoleName) VALUES ('Admin'), ('Customer');
GO

-- =====================================================
-- 2. ACCOUNTS (AccountID: 1 to 11)
-- =====================================================
INSERT INTO Accounts (RoleID, Email, Phone, Password, FirstName, LastName, Status, RejectReason) VALUES 
(1, 'admin@autowashpro.com', '0901234567', 'AdminPass123!', 'John', 'Admin', 'Active', NULL),
(2, 'customer1@gmail.com', '0911123456', 'CustPass101@', 'Michael', 'Johnson', 'Active', NULL),
(2, 'customer2@gmail.com', '0912234567', 'EmmaPass202#', 'Emma', 'Williams', 'Active', NULL),
(2, 'customer3@gmail.com', '0913345678', 'DavidPass303$', 'David', 'Jones', 'Active', NULL),
(2, 'customer4@gmail.com', '0914456789', 'SophiaPass404!', 'Sophia', 'Garcia', 'Active', NULL),
(2, 'business1@company.com', '0921123456', 'BizAdmin505#', 'James', 'Miller', 'Active', NULL),
(2, 'customer5@gmail.com', '0915567890', 'OliviaPass606@', 'Olivia', 'Davis', 'Pending', NULL),
(2, 'customer6@gmail.com', '0916678901', 'LiamPass808!', 'Liam', 'Moore', 'Active', NULL),
(2, 'customer7@gmail.com', '0917789012', 'IsabellaPass909#', 'Isabella', 'Taylor', 'Rejected', N'Invalid Corporate Registration Certificate Number.'),
(2, 'customer8@gmail.com', '0918890123', 'NoahPass1111$', 'Noah', 'Thomas', 'Active', NULL),
(2, 'customer9@gmail.com', '0919901234', 'AvaPass1212!', 'Ava', 'Jackson', 'Active', NULL);
GO

-- =====================================================
-- 3. LOYALTY TIERS (TierID: 1 to 4)
-- =====================================================
INSERT INTO LoyaltyTiers (TierName, MinSpend, PointMultiplier, BenefitDescription, IsActive) VALUES 
('Member', 0, 1.00, 'Basic member with standard points earning', 1),
('Silver', 5000000, 1.25, '5% discount on services and faster processing', 1),
('Gold', 15000000, 1.50, '10% discount, priority booking and free wax', 1),
('Platinum', 30000000, 2.00, '15% discount, VIP bays and complimentary detailing', 1);
GO

-- =====================================================
-- 4. CUSTOMERS
-- =====================================================
INSERT INTO Customers (AccountID, TierID, JoinedAt) VALUES 
(2, 1, '2025-01-15 08:30:00'),  -- CustomerID = 1
(3, 2, '2025-02-20 10:15:00'),  -- CustomerID = 2
(4, 1, '2025-03-10 14:45:00'),  -- CustomerID = 3
(5, 3, '2025-04-05 09:20:00'),  -- CustomerID = 4
(6, 2, '2025-05-12 11:00:00'),  -- CustomerID = 5 (Doanh nghiệp)
(7, 1, '2025-06-18 16:30:00'),  -- CustomerID = 6
(8, 4, '2025-07-22 08:45:00'),  -- CustomerID = 7 (Doanh nghiệp)
(9, 2, '2025-08-30 13:10:00'),  -- CustomerID = 8 (Doanh nghiệp Rejected)
(10, 3, '2025-09-14 10:25:00'), -- CustomerID = 9
(11, 1, '2025-10-05 15:50:00'); -- CustomerID = 10
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
-- 6, 7, 8. VEHICLE METADATA (Cần thiết để bảng Vehicles không lỗi)
-- =====================================================
INSERT INTO VehicleBrands (BrandName, Country, IsActive) VALUES ('Toyota', 'Japan', 1), ('Honda', 'Japan', 1), ('Ford', 'USA', 1);
INSERT INTO VehicleTypes (TypeName, Description, IsActive) VALUES ('Sedan', '4-door passenger car', 1), ('SUV', 'Sport Utility Vehicle', 1);
INSERT INTO VehicleModels (BrandID, VehicleTypeID, ModelName, IsActive) VALUES (1, 1, 'Camry', 1), (2, 2, 'CR-V', 1), (3, 2, 'Ranger', 1);
GO

-- =====================================================
-- 9. VEHICLES
-- =====================================================
INSERT INTO Vehicles (CustomerID, ModelID, LicensePlate, Color, ManufactureYear, Status) VALUES 
(1, 1, '51A-12345', 'White', 2022, 'Active'),
(2, 2, '51B-23456', 'Black', 2021, 'Active'),
(3, 3, '51C-34567', 'Silver', 2023, 'Active'),
(4, 1, '51D-45678', 'Blue', 2020, 'Active'),
(5, 2, '51E-56789', 'Red', 2022, 'Active'),
(6, 3, '51F-67890', 'Gray', 2019, 'Active'),
(7, 1, '51G-78901', 'White', 2023, 'Active'),
(8, 2, '51H-89012', 'Black', 2021, 'Active'),
(9, 3, '51K-90123', 'Blue', 2022, 'Active'),
(10, 1, '51L-01234', 'Silver', 2020, 'Active');
GO

-- =====================================================
-- 10. SERVICES
-- =====================================================
INSERT INTO Services (ServiceName, Description, IsActive) VALUES 
('Exterior Wash', 'Basic car wash with foam and rinse', 1),
('Interior Cleaning', 'Vacuum and wipe interior surfaces', 1),
('Full Detailing', 'Complete interior + exterior detailing', 1),
('Engine Wash', 'Clean engine bay', 1),
('Wax & Polish', 'Apply protective wax and polish', 1),
('Headlight Restoration', 'Restore clarity to headlights', 1),
('Tire & Wheel Cleaning', 'Deep clean tires and rims', 1),
('Ceramic Coating', 'Long-term paint protection', 1),
('Underbody Wash', 'Clean undercarriage', 1),
('Air Freshener Service', 'Premium scent application', 1);
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
INSERT INTO WashBays (BayName, Description, IsActive) VALUES 
('Bay A1', 'Standard bay near entrance', 1), ('Bay A2', 'Standard bay', 1),
('Bay B1', 'Premium detailing bay', 1), ('Bay B2', 'Premium bay with lift', 1),
('Bay C1', 'Express wash bay', 1), ('Bay C2', 'Express wash bay', 1),
('Bay VIP1', 'VIP customer bay', 1), ('Bay VIP2', 'VIP customer bay', 1),
('Bay D1', 'Large vehicle bay', 1), ('Bay D2', 'Electric vehicle compatible bay', 1);
GO

-- =====================================================
-- 12.5. TIME SLOTS (Ép kiểu an toàn không báo lỗi giờ)
-- =====================================================
INSERT INTO TimeSlots (StartTime, EndTime, IsAvailable) VALUES
(CAST(GETDATE() AS DATE), DATEADD(minute, 30, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), 1), 
(DATEADD(hour, 8, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), DATEADD(minute, 510, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), 1), 
(DATEADD(hour, 9, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), DATEADD(minute, 570, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), 0), 
(DATEADD(hour, 9, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), DATEADD(minute, 600, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), 1), 
(DATEADD(hour, 10, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), DATEADD(minute, 630, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), 1), 
(DATEADD(hour, 11, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), DATEADD(minute, 690, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), 1), 
(DATEADD(hour, 14, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), DATEADD(minute, 870, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), 1), 
(DATEADD(hour, 15, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), DATEADD(minute, 930, CAST(CAST(GETDATE() AS DATE) AS DATETIME)), 1); 
GO

-- =====================================================
-- 13. PROMOTIONS
-- =====================================================
INSERT INTO Promotions (PromoCode, PromotionName, TargetType, DiscountPercent, StartDate, EndDate, Description, IsActive) VALUES 
('SUMMER25', 'Summer Special', 'All', 25, '2026-06-01', '2026-08-31', '25% off all services', 1),
('FIRST10', 'First Time Discount', 'Customer', 15, '2026-01-01', '2026-12-31', '15% for new customers', 1),
('GOLDVIP', 'Gold Member Bonus', 'Tier', 20, '2026-01-01', '2026-12-31', 'Extra 20% for Gold tier', 1),
('FLEET30', 'Business Fleet', 'All', 30, '2026-01-01', '2026-12-31', '30% for business customers', 1),
('WEEKEND15', 'Weekend Special', 'All', 15, '2026-06-01', '2026-12-31', '15% off on weekends', 1),
('REFER10', 'Referral Bonus', 'Customer', 10, '2026-01-01', '2026-12-31', '10% for referred customers', 1),
('PLATINUM50', 'Platinum Exclusive', 'Tier', 50, '2026-05-01', '2026-07-31', '50% off for Platinum', 1),
('ECO10', 'Eco Friendly', 'All', 10, '2026-06-01', '2026-12-31', '10% for electric vehicles', 1);
GO

INSERT INTO PromotionTiers (PromotionID, TierID) VALUES (3,3),(3,4),(7,4);
INSERT INTO PromotionCustomers (PromotionID, CustomerID) VALUES (2,1),(2,2),(6,3),(6,4);
GO

-- =====================================================
-- 14. REWARDS
-- =====================================================
INSERT INTO Rewards (RewardName, RewardType, PointsRequired, DiscountPercent, DiscountAmount, StockQuantity, ExpiryDays, IsActive) VALUES 
('Free Exterior Wash', 'Voucher', 500, 100, NULL, 100, 30, 1),
('Interior Cleaning Voucher', 'Voucher', 800, 100, NULL, 80, 45, 1),
('10% Off Next Service', 'Voucher', 1200, 10, NULL, 150, 60, 1),
('Free Car Air Freshener', 'Gift', 300, NULL, NULL, 200, 90, 1),
('Premium Wax Voucher', 'Voucher', 2000, NULL, 500000, 50, 30, 1),
('Full Detailing Voucher', 'Voucher', 5000, 100, NULL, 30, 30, 1);
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
INSERT INTO Invoices (CustomerID, PromotionID, SubTotal, DiscountAmount, FinalAmount, PaymentStatus, PaymentMethod) VALUES 
(1, 1, 400000, 100000, 300000, 'Paid', 'Cash'),               
(2, NULL, 1200000, 120000, 1080000, 'Paid', 'BankTransfer'),   
(3, 5, 450000, 67500, 382500, 'Paid', 'Momo'),                 
(4, NULL, 2500000, 0, 2500000, 'Paid', 'CreditCard'),          
(5, 4, 300000, 90000, 210000, 'Paid', 'BankTransfer'),         
(5, 4, 300000, 90000, 210000, 'Paid', 'BankTransfer'),         
(6, NULL, 600000, 0, 600000, 'Unpaid', NULL),                  
(7, 8, 900000, 90000, 810000, 'Paid', 'Momo'),                 
(8, NULL, 1800000, 0, 1800000, 'Paid', 'Cash');                
GO

-- =====================================================
-- 18. BOOKINGS (Đã XÓA CỘT AppointmentTime khỏi câu lệnh Insert)
-- =====================================================
INSERT INTO Bookings (CustomerID, VehicleID, ServiceID, WashBayID, TimeSlotID, InvoiceID, Quantity, PriceAtOrder, DurationAtOrder, BookingDate, Status, Notes) VALUES 
(1, 1, 1, 1, 3, 1, 1, 150000, 30, GETDATE(), 'Completed', 'Exterior wash today'),
(1, 1, 2, 1, 3, 1, 1, 250000, 45, GETDATE(), 'Completed', 'Interior wash today'),
(2, 2, 3, 3, 4, 2, 1, 1200000, 150, GETDATE(), 'Completed', 'Full detailing service'),
(3, 3, 1, 2, 5, 3, 1, 200000, 40, GETDATE(), 'Completed', 'Standard appointment task'),
(4, 4, 8, 4, 6, 4, 1, 2500000, 180, GETDATE(), 'Completed', 'VIP ceramic service'),
(5, 5, 1, 7, 7, 5, 1, 300000, 40, GETDATE(), 'Completed', 'Corporate Fleet Order A'),
(5, 5, 1, 7, 8, 6, 1, 300000, 40, GETDATE(), 'Completed', 'Corporate Fleet Order B'),
(6, 6, 1, 1, 2, NULL, 1, 180000, 35, GETDATE(), 'Pending', 'Awaiting approval');
GO

-- =====================================================
-- 19. BOOKING DETAILS (Nạp dữ liệu cho bảng cũ để tránh bị lỗi)
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