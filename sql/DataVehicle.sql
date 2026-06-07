USE AutoWashProDB;
GO

-- =========================================================================
-- [DỌN DẸP DỮ LIỆU CŨ ĐỂ RESET SẠCH SẼ]
-- =========================================================================
DELETE FROM Vehicles;
DELETE FROM ServicePrices;
DELETE FROM VehicleModels;
DELETE FROM VehicleTypes;
DELETE FROM VehicleBrands;
GO

DBCC CHECKIDENT ('VehicleModels', RESEED, 0);
DBCC CHECKIDENT ('VehicleTypes', RESEED, 0);
DBCC CHECKIDENT ('VehicleBrands', RESEED, 0);
GO

-- =========================================================================
-- 1. INSERT CHUẨN XÁC 6 DÒNG XE THEO YÊU CẦU
-- =========================================================================
INSERT INTO VehicleTypes (TypeName, Description, IsActive)
VALUES
('Sedan', N'Dòng xe Sedan - 4 cửa, gầm thấp', 1),
('Hatchback', N'Dòng xe HatchBack - đuôi cụt, 5 cửa', 1),
('SUV', N'Dòng xe SUV – xe thể thao đa dụng', 1),
('Crossover', N'Dòng xe Crossover (CUV)', 1),
('MPV', N'Dòng xe MPV / Minivan – xe đa dụng', 1),
('Coupe', N'Dòng xe Coupe – xe thể thao mui kín', 1);
GO

-- =========================================================================
-- 2. INSERT 35 HÃNG XE (MỞ RỘNG TỐI ĐA TỪ BÌNH DÂN ĐẾN SIÊU XE)
-- =========================================================================
INSERT INTO VehicleBrands (BrandName, Country, IsActive)
VALUES
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

-- =========================================================================
-- 3. INSERT GẦN 200 MẪU XE (CHỈ NẰM TRONG 6 DÒNG XE ĐÃ CHỌN)
-- =========================================================================
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

USE AutoWashProDB;
GO
