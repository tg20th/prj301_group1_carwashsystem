-- =====================================================
-- Sample bookings for tomorrow linked to TimeSlots
-- Run after slots exist for the target date
-- =====================================================
USE AutoWashProDB;
GO

DECLARE @Tomorrow DATE = DATEADD(DAY, 1, CAST(GETDATE() AS DATE));

-- Ensure default slots exist for tomorrow
IF NOT EXISTS (SELECT 1 FROM TimeSlots WHERE SlotDate = @Tomorrow)
BEGIN
    RAISERROR('No time slots found for tomorrow. Open Time Slot Management and generate slots first.', 16, 1);
    RETURN;
END
GO

DECLARE @Tomorrow DATE = DATEADD(DAY, 1, CAST(GETDATE() AS DATE));

-- Booking 1: 08:00 - 08:30 | Confirmed
INSERT INTO Bookings (CustomerID, VehicleID, ServiceID, WashBayID, TimeSlotID, InvoiceID,
    Quantity, PriceAtOrder, DurationAtOrder, BookingDate, Status, Notes)
SELECT 1, 1, 1, 1, t.TimeSlotID, NULL, 1, 180000, 30, t.StartTime, 'Confirmed',
    'Tomorrow booking - Exterior Wash 08:00'
FROM TimeSlots t
WHERE t.SlotDate = @Tomorrow
  AND CONVERT(VARCHAR(5), t.StartTime, 108) = '08:00'
  AND NOT EXISTS (SELECT 1 FROM Bookings b WHERE b.TimeSlotID = t.TimeSlotID AND b.Status NOT IN ('Cancelled', 'NoShow'));

UPDATE TimeSlots SET Status = 'UNAVAILABLE'
WHERE SlotDate = @Tomorrow AND CONVERT(VARCHAR(5), StartTime, 108) = '08:00';
GO

DECLARE @Tomorrow DATE = DATEADD(DAY, 1, CAST(GETDATE() AS DATE));

-- Booking 2: 09:00 - 09:30 | Pending
INSERT INTO Bookings (CustomerID, VehicleID, ServiceID, WashBayID, TimeSlotID, InvoiceID,
    Quantity, PriceAtOrder, DurationAtOrder, BookingDate, Status, Notes)
SELECT 2, 2, 2, 2, t.TimeSlotID, NULL, 1, 250000, 45, t.StartTime, 'Pending',
    'Tomorrow booking - Interior Cleaning 09:00'
FROM TimeSlots t
WHERE t.SlotDate = @Tomorrow
  AND CONVERT(VARCHAR(5), t.StartTime, 108) = '09:00'
  AND NOT EXISTS (SELECT 1 FROM Bookings b WHERE b.TimeSlotID = t.TimeSlotID AND b.Status NOT IN ('Cancelled', 'NoShow'));

UPDATE TimeSlots SET Status = 'UNAVAILABLE'
WHERE SlotDate = @Tomorrow AND CONVERT(VARCHAR(5), StartTime, 108) = '09:00';
GO

DECLARE @Tomorrow DATE = DATEADD(DAY, 1, CAST(GETDATE() AS DATE));

-- Booking 3: 10:30 - 11:00 | Confirmed
INSERT INTO Bookings (CustomerID, VehicleID, ServiceID, WashBayID, TimeSlotID, InvoiceID,
    Quantity, PriceAtOrder, DurationAtOrder, BookingDate, Status, Notes)
SELECT 3, 3, 3, 3, t.TimeSlotID, NULL, 1, 1200000, 150, t.StartTime, 'Confirmed',
    'Tomorrow booking - Full Detailing 10:30'
FROM TimeSlots t
WHERE t.SlotDate = @Tomorrow
  AND CONVERT(VARCHAR(5), t.StartTime, 108) = '10:30'
  AND NOT EXISTS (SELECT 1 FROM Bookings b WHERE b.TimeSlotID = t.TimeSlotID AND b.Status NOT IN ('Cancelled', 'NoShow'));

UPDATE TimeSlots SET Status = 'UNAVAILABLE'
WHERE SlotDate = @Tomorrow AND CONVERT(VARCHAR(5), StartTime, 108) = '10:30';
GO

DECLARE @Tomorrow DATE = DATEADD(DAY, 1, CAST(GETDATE() AS DATE));

-- Booking 4: 14:00 - 14:30 | Confirmed
INSERT INTO Bookings (CustomerID, VehicleID, ServiceID, WashBayID, TimeSlotID, InvoiceID,
    Quantity, PriceAtOrder, DurationAtOrder, BookingDate, Status, Notes)
SELECT 4, 4, 1, 4, t.TimeSlotID, NULL, 1, 200000, 40, t.StartTime, 'Confirmed',
    'Tomorrow booking - Exterior Wash 14:00'
FROM TimeSlots t
WHERE t.SlotDate = @Tomorrow
  AND CONVERT(VARCHAR(5), t.StartTime, 108) = '14:00'
  AND NOT EXISTS (SELECT 1 FROM Bookings b WHERE b.TimeSlotID = t.TimeSlotID AND b.Status NOT IN ('Cancelled', 'NoShow'));

UPDATE TimeSlots SET Status = 'UNAVAILABLE'
WHERE SlotDate = @Tomorrow AND CONVERT(VARCHAR(5), StartTime, 108) = '14:00';
GO

DECLARE @Tomorrow DATE = DATEADD(DAY, 1, CAST(GETDATE() AS DATE));

-- Booking 5: 16:00 - 16:30 | Pending
INSERT INTO Bookings (CustomerID, VehicleID, ServiceID, WashBayID, TimeSlotID, InvoiceID,
    Quantity, PriceAtOrder, DurationAtOrder, BookingDate, Status, Notes)
SELECT 5, 5, 8, 7, t.TimeSlotID, NULL, 1, 2500000, 180, t.StartTime, 'Pending',
    'Tomorrow booking - Ceramic Coating 16:00'
FROM TimeSlots t
WHERE t.SlotDate = @Tomorrow
  AND CONVERT(VARCHAR(5), t.StartTime, 108) = '16:00'
  AND NOT EXISTS (SELECT 1 FROM Bookings b WHERE b.TimeSlotID = t.TimeSlotID AND b.Status NOT IN ('Cancelled', 'NoShow'));

UPDATE TimeSlots SET Status = 'UNAVAILABLE'
WHERE SlotDate = @Tomorrow AND CONVERT(VARCHAR(5), StartTime, 108) = '16:00';
GO

-- Booking details
INSERT INTO BookingDetails (BookingID, ServiceID, Quantity, PriceAtOrder, DurationAtOrder)
SELECT b.BookingID, b.ServiceID, b.Quantity, b.PriceAtOrder, b.DurationAtOrder
FROM Bookings b
WHERE b.Notes LIKE 'Tomorrow booking%'
  AND NOT EXISTS (SELECT 1 FROM BookingDetails d WHERE d.BookingID = b.BookingID);
GO

PRINT 'Tomorrow sample bookings created successfully.';
GO