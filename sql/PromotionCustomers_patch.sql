-- Patch: PromotionCustomers quota per account
-- Run on existing AutoWashProDB if table is missing or lacks MaxUses/UsedCount

USE AutoWashProDB;
GO

IF OBJECT_ID('PromotionCustomers', 'U') IS NULL
BEGIN
    CREATE TABLE PromotionCustomers (
        PromotionID INT NOT NULL,
        CustomerID INT NOT NULL,
        MaxUses INT NOT NULL DEFAULT 1,
        UsedCount INT NOT NULL DEFAULT 0,
        PRIMARY KEY(PromotionID, CustomerID),
        CONSTRAINT FK_PromoCustomers_Promo FOREIGN KEY(PromotionID) REFERENCES Promotions(PromotionID) ON DELETE CASCADE,
        CONSTRAINT FK_PromoCustomers_Customer FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID),
        CONSTRAINT CK_PromoCustomers_Uses CHECK (UsedCount >= 0 AND UsedCount <= MaxUses)
    );
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('PromotionCustomers') AND name = 'MaxUses'
)
BEGIN
    ALTER TABLE PromotionCustomers ADD MaxUses INT NOT NULL DEFAULT 1;
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('PromotionCustomers') AND name = 'UsedCount'
)
BEGIN
    ALTER TABLE PromotionCustomers ADD UsedCount INT NOT NULL DEFAULT 0;
END
GO