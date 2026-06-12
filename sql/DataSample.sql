USE AutoWashProDB;
GO

-- =====================================================
-- 1. ROLES (Chỉ 2 role)
-- =====================================================
INSERT INTO Roles (RoleName) VALUES 
('Admin'), ('Customer');
GO

-- =====================================================
-- 2. ACCOUNTS
-- =====================================================
INSERT INTO Accounts (RoleID, Email, Phone, Password, FirstName, LastName, Status) VALUES 
(1, 'admin@autowashpro.com', '0901234567', 'AdminPass123!', 'John', 'Admin', 'Active'),
(2, 'customer1@gmail.com', '0911123456', 'CustPass101@', 'Michael', 'Johnson', 'Active'),
(2, 'customer2@gmail.com', '0912234567', 'EmmaPass202#', 'Emma', 'Williams', 'Active'),
(2, 'customer3@gmail.com', '0913345678', 'DavidPass303$', 'David', 'Jones', 'Active'),
(2, 'customer4@gmail.com', '0914456789', 'SophiaPass404!', 'Sophia', 'Garcia', 'Active'),
(2, 'business1@company.com', '0921123456', 'BizAdmin505#', 'James', 'Miller', 'Active'),
(2, 'customer5@gmail.com', '0915567890', 'OliviaPass606@', 'Olivia', 'Davis', 'Active'),
(2, 'customer6@gmail.com', '0916678901', 'LiamPass808!', 'Liam', 'Moore', 'Active'),
(2, 'customer7@gmail.com', '0917789012', 'IsabellaPass909#', 'Isabella', 'Taylor', 'Active'),
(2, 'customer8@gmail.com', '0918890123', 'NoahPass1111$', 'Noah', 'Thomas', 'Active'),
(2, 'customer9@gmail.com', '0919901234', 'AvaPass1212!', 'Ava', 'Jackson', 'Active');
GO

-- =====================================================
-- 3. LOYALTY TIERS (4 hạng)
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
(2,1,'2025-01-15 08:30:00'),  -- CustomerID = 1
(3,2,'2025-02-20 10:15:00'),  -- 2
(4,1,'2025-03-10 14:45:00'),  -- 3
(5,3,'2025-04-05 09:20:00'),  -- 4
(6,2,'2025-05-12 11:00:00'),  -- 5
(7,1,'2025-06-18 16:30:00'),  -- 6
(8,4,'2025-07-22 08:45:00'),  -- 7
(9,2,'2025-08-30 13:10:00'),  -- 8
(10,3,'2025-09-14 10:25:00'), -- 9
(11,1,'2025-10-05 15:50:00'); -- 10
GO

-- =====================================================
-- 5. BUSINESS CUSTOMERS
-- =====================================================
INSERT INTO BusinessCustomers (CustomerID, CompanyName, TaxCode, CompanyAddress) VALUES 
(5, 'Tech Solutions Ltd', '0101234567', '123 District 1, Ho Chi Minh City'),
(8, 'Logistics Express', '0209876543', '456 District 7, Ho Chi Minh City'),
(6, 'Auto Fleet Management', '0405566778', '101 District 9, Ho Chi Minh City');
GO

-- =====================================================
-- 9. VEHICLES (Bỏ Brands, Types, Models)
-- =====================================================
INSERT INTO Vehicles (CustomerID, ModelID, LicensePlate, Color, ManufactureYear, Status) VALUES 
(1,1,'51A-12345','White',2022,'Active'),
(2,2,'51B-23456','Black',2021,'Active'),
(3,3,'51C-34567','Silver',2023,'Active'),
(4,4,'51D-45678','Blue',2020,'Active'),
(5,5,'51E-56789','Red',2022,'Active'),
(6,6,'51F-67890','Gray',2019,'Active'),
(7,7,'51G-78901','White',2023,'Active'),
(8,8,'51H-89012','Black',2021,'Active'),
(9,9,'51K-90123','Blue',2022,'Active'),
(10,10,'51L-01234','Silver',2020,'Active');
GO

-- =====================================================
-- 10. SERVICES
-- =====================================================
INSERT INTO Services (ServiceName, Description, IsActive) VALUES 
('Exterior Wash','Basic car wash with foam and rinse',1),
('Interior Cleaning','Vacuum and wipe interior surfaces',1),
('Full Detailing','Complete interior + exterior detailing',1),
('Engine Wash','Clean engine bay',1),
('Wax & Polish','Apply protective wax and polish',1),
('Headlight Restoration','Restore clarity to headlights',1),
('Tire & Wheel Cleaning','Deep clean tires and rims',1),
('Ceramic Coating','Long-term paint protection',1),
('Underbody Wash','Clean undercarriage',1),
('Air Freshener Service','Premium scent application',1);
GO

-- =====================================================
-- 11. SERVICE PRICES (Chỉ dùng VehicleTypeID có sẵn)
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
('Bay A1','Standard bay near entrance',1),('Bay A2','Standard bay',1),
('Bay B1','Premium detailing bay',1),('Bay B2','Premium bay with lift',1),
('Bay C1','Express wash bay',1),('Bay C2','Express wash bay',1),
('Bay VIP1','VIP customer bay',1),('Bay VIP2','VIP customer bay',1),
('Bay D1','Large vehicle bay',1),('Bay D2','Electric vehicle compatible bay',1);
GO

-- =====================================================
-- 13. PROMOTIONS
-- =====================================================
INSERT INTO Promotions (PromoCode, PromotionName, TargetType, DiscountPercent, StartDate, EndDate, Description, IsActive) VALUES 
('SUMMER25','Summer Special','All',25,'2026-06-01','2026-08-31','25% off all services',1),
('FIRST10','First Time Discount','Customer',15,'2026-01-01','2026-12-31','15% for new customers',1),
('GOLDVIP','Gold Member Bonus','Tier',20,'2026-01-01','2026-12-31','Extra 20% for Gold tier',1),
('FLEET30','Business Fleet','All',30,'2026-01-01','2026-12-31','30% for business customers',1),
('WEEKEND15','Weekend Special','All',15,'2026-06-01','2026-12-31','15% off on weekends',1),
(NULL,'Referral Bonus','Customer',10,'2026-01-01','2026-12-31','10% for referred customers',1),
('PLATINUM50','Platinum Exclusive','Tier',50,'2026-05-01','2026-07-31','50% off for Platinum',1),
('ECO10','Eco Friendly','All',10,'2026-06-01','2026-12-31','10% for electric vehicles',1);
GO

INSERT INTO PromotionTiers (PromotionID, TierID) VALUES 
(3,3),(3,4),(7,4);
GO

INSERT INTO PromotionCustomers (PromotionID, CustomerID) VALUES 
(2,1),(2,2),(6,3),(6,4);
GO

-- =====================================================
-- 14. REWARDS
-- =====================================================
INSERT INTO Rewards (RewardName, RewardType, PointsRequired, DiscountPercent, DiscountAmount, StockQuantity, ExpiryDays, IsActive) VALUES 
('Free Exterior Wash','Voucher',500,100,NULL,100,30,1),
('Interior Cleaning Voucher','Voucher',800,100,NULL,80,45,1),
('10% Off Next Service','Voucher',1200,10,NULL,150,60,1),
('Free Car Air Freshener','Gift',300,NULL,NULL,200,90,1),
('Premium Wax Voucher','Voucher',2000,NULL,500000,50,30,1),
('Full Detailing Voucher','Voucher',5000,100,NULL,30,30,1);
GO

-- =====================================================
-- 15. POINT TRANSACTIONS
-- =====================================================
INSERT INTO PointTransactions (CustomerID, PointChange, TransactionType, Note) VALUES 
(1,250,'Earn','First service points'),
(2,450,'Earn','Monthly wash'),
(3,1200,'Earn','Full detailing'),
(4,600,'Earn','Business fleet wash'),
(5,350,'Earn','Regular service'),
(6,900,'Earn','VIP service'),
(1,800,'Earn','Referral bonus');
GO

-- =====================================================
-- 16. CUSTOMER REWARDS
-- =====================================================
INSERT INTO CustomerRewards (CustomerID, RewardID, Status) VALUES 
(1,1,'Available'),(2,2,'Available'),(3,3,'Available'),
(4,4,'Available'),(5,5,'Available'),(6,6,'Available');
GO

-- =====================================================
-- 17. INVOICES
-- =====================================================
INSERT INTO Invoices (CustomerID, PromotionID, SubTotal, DiscountAmount, FinalAmount, PaymentStatus, PaymentMethod) VALUES 
(1,1,800000,200000,600000,'Paid','Cash'),
(2,NULL,1200000,120000,1080000,'Paid','BankTransfer'),
(3,5,450000,67500,382500,'Paid','Momo'),
(4,NULL,2500000,0,2500000,'Paid','CreditCard'),
(5,4,3500000,1050000,2450000,'Paid','BankTransfer'),
(6,NULL,600000,0,600000,'Unpaid',NULL),
(7,8,900000,90000,810000,'Paid','Momo'),
(8,NULL,1800000,0,1800000,'Paid','Cash');
GO

-- =====================================================
-- 18. BOOKINGS (Mỗi booking chỉ 1 dịch vụ)
-- =====================================================
INSERT INTO Bookings (CustomerID, VehicleID, ServiceID, WashBayID, InvoiceID, 
                      Quantity, PriceAtOrder, DurationAtOrder, 
                      AppointmentTime, Status, Notes) 
VALUES 
(1,1,1,1,1, 1,150000,30, '2026-06-15 09:00:00','Completed','Regular wash'),           -- Exterior Wash
(1,1,2,1,1, 1,250000,45, '2026-06-15 09:45:00','Completed','Interior'),               -- Thêm booking cùng invoice

(2,2,3,3,2, 1,1200000,150,'2026-06-16 10:30:00','Completed','Full service'),
(3,3,1,2,3, 1,200000,40, '2026-06-17 14:00:00','Completed',''),
(4,4,8,4,4, 1,2500000,180,'2026-06-18 08:00:00','Completed','VIP service'),
(5,5,1,7,5, 5,200000,40, '2026-06-19 11:00:00','Completed','Fleet wash'),            -- 5 xe
(6,6,1,1,NULL,1,180000,35,'2026-06-20 09:30:00','Pending',''),
(7,7,3,5,7, 1,950000,130,'2026-06-21 15:00:00','Completed',''),
(8,8,4,8,8, 1,300000,40, '2026-06-22 13:00:00','Completed','');
GO

-- =====================================================
-- 19. BOOKING DETAILS
-- =====================================================
INSERT INTO BookingDetails (BookingID, ServiceID, Quantity, PriceAtOrder, DurationAtOrder) VALUES 
(1,1,1,150000,30),(1,2,1,250000,45),
(2,3,1,1200000,150),(3,1,1,200000,40),
(4,8,1,2500000,180),(5,1,5,200000,40),
(6,1,1,180000,35),(7,3,1,950000,130),
(8,4,1,300000,40);
GO

GO