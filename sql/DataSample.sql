USE AutoWashProDB;
GO

-- =========================================================================
-- [DỌN DẸP DỮ LIỆU CŨ ĐỂ ĐỒNG BỘ ID TỪ 1]
-- LƯU Ý: Không xóa bảng Brand, Type, Model vì đã có dữ liệu chuẩn ở bước trước
-- =========================================================================
DELETE FROM InvoiceDetails;
DELETE FROM PointTransactions;
DELETE FROM Invoices;
DELETE FROM CustomerRewards;
DELETE FROM Rewards;
DELETE FROM Promotions;
DELETE FROM WashBays;
DELETE FROM ServicePrices;
DELETE FROM Services;
DELETE FROM Vehicles;
DELETE FROM BusinessCustomers;
DELETE FROM Customers;
DELETE FROM LoyaltyTiers;
DELETE FROM Accounts;
DELETE FROM Roles;
GO

DBCC CHECKIDENT ('InvoiceDetails', RESEED, 0);
DBCC CHECKIDENT ('PointTransactions', RESEED, 0);
DBCC CHECKIDENT ('Invoices', RESEED, 0);
DBCC CHECKIDENT ('CustomerRewards', RESEED, 0);
DBCC CHECKIDENT ('Rewards', RESEED, 0);
DBCC CHECKIDENT ('Promotions', RESEED, 0);
DBCC CHECKIDENT ('WashBays', RESEED, 0);
DBCC CHECKIDENT ('Services', RESEED, 0);
DBCC CHECKIDENT ('Vehicles', RESEED, 0);
DBCC CHECKIDENT ('Customers', RESEED, 0);
DBCC CHECKIDENT ('Accounts', RESEED, 0);
DBCC CHECKIDENT ('LoyaltyTiers', RESEED, 0);
DBCC CHECKIDENT ('Roles', RESEED, 0);
GO

-- =========================================================================
-- 1. BẢNG PHÂN QUYỀN (ROLES)
-- =========================================================================
INSERT INTO Roles (RoleName) VALUES ('Admin'), ('Customer');
GO

-- =========================================================================
-- 2. BẢNG HẠNG THÀNH VIÊN (LOYALTY TIERS) - (Theo đúng File Docx)
-- =========================================================================
INSERT INTO LoyaltyTiers (TierName, MinSpend, PointMultiplier, BookingWindowDays, PriorityLevel, BenefitDescription, IsActive)
VALUES 
('Member', 0, 1.00, 7, 1, N'1 point = 1,000 VND spent', 1),
('Silver', 2000000, 1.10, 10, 2, N'+10% points, priority slot', 1),
('Gold', 6000000, 1.20, 12, 3, N'+20% points, free upgrade monthly', 1),
('Platinum', 15000000, 1.30, 14, 4, N'+30% points, free wash monthly', 1);
GO

-- =========================================================================
-- 3. BẢNG TÀI KHOẢN (ACCOUNTS)
-- =========================================================================
INSERT INTO Accounts (RoleID, Email, Phone, PasswordHash, FirstName, LastName, Status)
VALUES 
-- ADMIN (ID 1 -> 2)
(1, 'admin1@autowash.com', '0900000001', 'hashed_pw', 'System', 'Admin', 'Active'),
(1, 'manager@autowash.com', '0900000002', 'hashed_pw', 'Store', 'Manager', 'Active'),

-- CUSTOMERS CÁ NHÂN (ID 3 -> 12)
(2, 'nguyenvana@gmail.com', '0911111111', 'hashed_pw', 'Nguyen', 'Van A', 'Active'),
(2, 'tranthib@gmail.com', '0922222222', 'hashed_pw', 'Tran', 'Thi B', 'Active'),
(2, 'lehoangc@gmail.com', '0933333333', 'hashed_pw', 'Le', 'Hoang C', 'Active'),
(2, 'phamvand@gmail.com', '0944444444', 'hashed_pw', 'Pham', 'Van D', 'Active'),
(2, 'vuongthie@gmail.com', '0955555555', 'hashed_pw', 'Vuong', 'Thi E', 'Pending'), -- Chờ duyệt
(2, 'hoangvanf@gmail.com', '0966666666', 'hashed_pw', 'Hoang', 'Van F', 'Frozen'),  -- Đóng băng
(2, 'ngothig@gmail.com', '0977777777', 'hashed_pw', 'Ngo', 'Thi G', 'Active'),
(2, 'doanh@gmail.com', '0988888888', 'hashed_pw', 'Do', 'Anh H', 'Active'),
(2, 'dangvani@gmail.com', '0999999999', 'hashed_pw', 'Dang', 'Van I', 'Active'),
(2, 'lythik@gmail.com', '0910101010', 'hashed_pw', 'Ly', 'Thi K', 'Active'),

-- CUSTOMERS DOANH NGHIỆP (ID 13 -> 15)
(2, 'contact@fpt.com.vn', '0287300111', 'hashed_pw', 'Nguyen', 'Dai Dien FPT', 'Active'),
(2, 'admin@vinasun.vn', '0287300222', 'hashed_pw', 'Tran', 'Dai Dien Vinasun', 'Active'),
(2, 'transport@logistics.vn', '0287300333', 'hashed_pw', 'Le', 'Dai Dien Logistics', 'Active');
GO

-- =========================================================================
-- 4. BẢNG KHÁCH HÀNG (CUSTOMERS)
-- =========================================================================
INSERT INTO Customers (AccountID, TierID)
VALUES 
-- Khách cá nhân (ID 1 -> 10)
(3, 4), -- Nguyễn Văn A (Platinum)
(4, 3), -- Trần Thị B (Gold)
(5, 2), -- Lê Hoàng C (Silver)
(6, 1), (7, 1), (8, 1), (9, 2), (10, 3), (11, 1), (12, 1),

-- Khách doanh nghiệp (ID 11 -> 13)
(13, 4), -- FPT (Platinum)
(14, 4), -- Vinasun (Platinum)
(15, 3); -- Logistics (Gold)
GO

-- =========================================================================
-- 4.1. BẢNG KHÁCH DOANH NGHIỆP (BUSINESS CUSTOMERS)
-- =========================================================================
INSERT INTO BusinessCustomers (CustomerID, CompanyName, TaxCode, CompanyAddress)
VALUES 
(11, 'Cong ty Co phan FPT', '0101248141', N'Khu Công nghệ cao, TP. Thủ Đức, TP.HCM'),
(12, 'Cong ty Co phan Anh Duong (Vinasun)', '0302731736', N'Quận 1, TP.HCM'),
(13, 'Giao Hang Nhanh Logistics', '0311907295', N'Quận 7, TP.HCM');
GO

-- =========================================================================
-- 5. BẢNG KHOANG RỬA XE (WASH BAYS)
-- =========================================================================
INSERT INTO WashBays (BayName, Description, IsActive)
VALUES 
('Bay 1 - Standard', N'Khoang rửa tiêu chuẩn số 1', 1),
('Bay 2 - Standard', N'Khoang rửa tiêu chuẩn số 2', 1),
('Bay 3 - Express', N'Khoang rửa nhanh (Dưới 15 phút)', 1),
('Bay 4 - VIP', N'Khoang rửa ưu tiên cho hạng Silver trở lên', 1),
('Bay 5 - Detailing', N'Khoang chăm sóc chuyên sâu (Đánh bóng, Phủ Ceramic)', 1);
GO

-- =========================================================================
-- 6. BẢNG DỊCH VỤ GỐC (SERVICES)
-- =========================================================================
INSERT INTO Services (ServiceName, Description, IsActive)
VALUES 
(N'Rửa xe cơ bản (Basic Wash)', N'Rửa bọt tuyết, xịt gầm, lau khô', 1),
(N'Rửa xe cao cấp (Premium Wash)', N'Rửa bọt tuyết, x