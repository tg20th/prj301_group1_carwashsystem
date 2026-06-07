
    -- =========================================================================
    -- Lấy điểm thưởng của khách trong 12 tháng đổ lại
    -- ==========================================================================
    SELECT a.AccountID,
    c.TierID,
    -- Tính tổng điểm, nếu không có giao dịch (NULL) thì gán bằng 0
    ISNULL(SUM(pt.PointChange), 0) AS CurrentPoints
    FROM Accounts a
    INNER JOIN Customers c ON a.AccountID = c.AccountID
    LEFT JOIN PointTransactions pt ON c.CustomerID = pt.CustomerID 
    -- Điều kiện lọc: Chỉ lấy giao dịch trong vòng 12 tháng đổ lại
    AND pt.TransactionDate >= DATEADD(MONTH, -12, GETDATE())
    WHERE a.AccountID = ?
    GROUP BY 
    a.AccountID, 
    c.TierID; 