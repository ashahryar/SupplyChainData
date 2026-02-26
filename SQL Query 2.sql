SELECT 
    p.Category,
    SUM(f.ShippingDays) AS TotalQuantity
FROM FactShipments f
JOIN DimProducts p ON f.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY TotalQuantity DESC;

SELECT 
	w.RouteName,
	AVG (f.ShippingDays) AS AvgShippingDays
FROM FactShipments f
JOIN DimWarehouse w ON f.WarehouseID = w.WarehouseID
GROUP BY w.RouteName
ORDER BY AvgShippingDays DESC;

SELECT 
    s.Suppliername,
    SUM(f.TotalCosts) AS TotalShippmentValue
FROM FactShipments f
JOIN Dimsupplier s ON f.SupplierID = s.SupplierID
GROUP BY s.Suppliername
ORDER BY TotalShippmentValue DESC;

SELECT TOP 5
    p.ProductCode,
    p.Category,
    SUM(f.ShippingDays) AS TotalQuantity
FROM FactShipments f
JOIN DimProducts p ON f.ProductID = p.ProductID
GROUP BY p.ProductCode, p.Category
ORDER BY TotalQuantity DESC;

SELECT 
    p.Category,
    COUNT(f.ShipmentID) AS TotalShipments,
    MIN(f.TotalCosts) AS MinValue,
    MAX(f.TotalCosts) AS MaxValue,
    AVG(f.TotalCosts) AS AvgValue,
    SUM(f.TotalCosts) AS TotalValue
FROM FactShipments f
JOIN DimProducts p ON f.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY TotalValue DESC;


---------------------------------------------ADVANCE QUERY----------------------------------------------------------



------------------------Stored Procedure----------------------------
CREATE PROCEDURE UpdateShipment
    @ShipmentID INT,
    @NewShippingDays INT
AS
BEGIN
    UPDATE FactShipments
    SET ShippingDays = @NewShippingDays
    WHERE ShipmentID = @ShipmentID;
END;

EXEC UpdateShipment @ShipmentID = 1, @NewShippingDays = 10;
SELECT ShipmentID, ShippingDays FROM FactShipments WHERE ShipmentID = 1;

-----------------------view--------------------

CREATE VIEW ShipmentSummary AS
SELECT 
    p.Category,
    SUM(f.ShippingDays) AS TotalQuantity,
    AVG(f.ShippingDays) AS AvgShippingDays,
    COUNT(f.ShipmentID	) AS TotalShipments
FROM FactShipments f
JOIN DimProducts p ON f.ProductID = p.ProductID
GROUP BY p.Category;
SELECT * FROM ShipmentSummary;


-------------------LAG FUNCTION for previous year --------------------------

SELECT 
    s.Suppliername,
    SUM(f.TotalCosts) AS TotalValue,
    LAG(SUM(f.TotalCosts)) OVER (
        PARTITION BY s.Suppliername 
        ORDER BY t.Year
    ) AS PreviousYearValue
FROM FactShipments f
JOIN Dimsupplier s ON f.SupplierID = s.SupplierID
JOIN DimTime t ON f.TimeID = t.TimeID
GROUP BY s.Suppliername, t.Year;
------ Note: NULL values indicate no previous year data available
-- as dataset contains only single year records--------------------------------

----------------------------------------------TRIGGER for Maintain history------------------------
CREATE TABLE ShipmentHistory (
    HistoryID INT PRIMARY KEY IDENTITY(1,1),
    ShipmentID INT,
    OldShippingDays INT,
    ChangedAt DATETIME DEFAULT GETDATE(),
    Action NVARCHAR(10)
);

CREATE TRIGGER TrackShipmentChanges
ON FactShipments
AFTER UPDATE, DELETE
AS
BEGIN
    INSERT INTO ShipmentHistory (ShipmentID, OldShippingDays, Action)
    SELECT 
        ShipmentID,
        ShippingDays,
        CASE 
            WHEN EXISTS (SELECT 1 FROM inserted) THEN 'UPDATE'
            ELSE 'DELETE'
        END
    FROM deleted;
END;

-- Pehle update karo
EXEC UpdateShipment @ShipmentID = 1, @NewShippingDays = 15;

-- Phir history check karo
SELECT * FROM ShipmentHistory;