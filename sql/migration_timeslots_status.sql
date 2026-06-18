-- =====================================================
-- Migration: TimeSlots - IsAvailable BIT -> Status VARCHAR
-- Run against existing AutoWashProDB database
-- =====================================================
USE AutoWashProDB;
GO

-- Step 1: Add new columns
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('TimeSlots') AND name = 'SlotDate')
BEGIN
    ALTER TABLE TimeSlots ADD SlotDate DATE NULL;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('TimeSlots') AND name = 'Status')
BEGIN
    ALTER TABLE TimeSlots ADD Status VARCHAR(20) NULL;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('TimeSlots') AND name = 'MaintenanceNote')
BEGIN
    ALTER TABLE TimeSlots ADD MaintenanceNote NVARCHAR(500) NULL;
END
GO

-- Step 2: Migrate existing data
UPDATE TimeSlots
SET SlotDate = CAST(StartTime AS DATE),
    Status = CASE
        WHEN IsAvailable = 1 THEN 'AVAILABLE'
        ELSE 'UNAVAILABLE'
    END
WHERE SlotDate IS NULL OR Status IS NULL;
GO

-- Step 3: Make columns NOT NULL
ALTER TABLE TimeSlots ALTER COLUMN SlotDate DATE NOT NULL;
ALTER TABLE TimeSlots ALTER COLUMN Status VARCHAR(20) NOT NULL;
GO

-- Step 4: Add check constraint
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_TimeSlots_Status')
BEGIN
    ALTER TABLE TimeSlots
    ADD CONSTRAINT CK_TimeSlots_Status
    CHECK (Status IN ('AVAILABLE', 'UNAVAILABLE', 'MAINTENANCE'));
END
GO

-- Step 5: Drop default constraint on IsAvailable (if exists) then drop column
DECLARE @constraintName NVARCHAR(200);
SELECT @constraintName = dc.name
FROM sys.default_constraints dc
JOIN sys.columns c ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id
WHERE dc.parent_object_id = OBJECT_ID('TimeSlots') AND c.name = 'IsAvailable';

IF @constraintName IS NOT NULL
BEGIN
    EXEC('ALTER TABLE TimeSlots DROP CONSTRAINT ' + @constraintName);
END
GO

IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('TimeSlots') AND name = 'IsAvailable')
BEGIN
    ALTER TABLE TimeSlots DROP COLUMN IsAvailable;
END
GO

PRINT 'TimeSlots migration completed successfully.';
GO