CREATE DATABASE SupplyChainDW;
GO;
USE SupplyChainDW;
GO

Create table DimProducts(
	ProductID INT primary key identity(1,1),
	ProductCode NVARCHAR(50),
	Category    NVARCHAR(50),
	UnitPrice   DECIMAL(10,2),
	StockAvailable INT,
);

Create table Dimsupplier(
	SupplierID INT PRIMARY KEY IDENTITY (1,1),
	Suppliername NVARCHAR(50),
	location     NVARCHAR(100),
);

Create table DimWarehouse(
	WarehouseID INT PRIMARY KEY IDENTITY(1,1),
	RouteName     NVARCHAR (50),
	TransportMode NVARCHAR(50),
	location      NVARCHAR(100),
);

Create table DimTime(
	TimeID INT PRIMARY KEY IDENTITY(1,1),
	MonthName   NVARCHAR (20),
	Date        DATE ,
	MonthNumber INT	,
	Quarter		INT,
	Year		INT,
);

Create table DimOrder(
	OrderID INT PRIMARY KEY IDENTITY(1,1),
	OrderQuantity INT ,
	CustomerType NVARCHAR(50),
	Revenue		DECIMAL (10,2),
);

Create Table FactShipments(
	ShipmentID  INT PRIMARY KEY IDENTITY(1,1),
	ProductID   INT FOREIGN KEY REFERENCES DimProducts(ProductID),
	SupplierID  INT FOREIGN KEY REFERENCES DimSupplier(SupplierID),
	WarehouseID INT FOREIGN KEY REFERENCES DimWarehouse(WarehouseID),
	TimeID      INT FOREIGN KEY REFERENCES DimTime(TimeID),
	OrderID     INT FOREIGN KEY REFERENCES DimOrder(OrderID),
	ShippingCosts DECIMAL (10,2),
	TotalCosts    DECIMAL (10,2),
	ShippingDays  INT 
);

SELECT * FROM supply_chain_data;

INSERT INTO DimProducts (ProductCode, Category, UnitPrice, StockAvailable)
SELECT 
    SKU,
    Product_type,
    Price,
    Stock_levels
FROM supply_chain_data;

SELECT * FROM DimProducts

INSERT INTO Dimsupplier (Suppliername, location)
SELECT 
	Supplier_name,
	Location
FROM supply_chain_data;
SELECT * FROM Dimsupplier

INSERT INTO DimWarehouse (RouteName, location, TransportMode)
SELECT 
	Routes,
	Transportation_modes,
	location
FROM supply_chain_data;
SELECT * FROM DimWarehouse

INSERT INTO DimTime (Date, MonthNumber, MonthName, Quarter, Year)
VALUES 
('2023-01-01', 1, 'January', 1, 2023),
('2023-02-01', 2, 'February', 1, 2023),
('2023-03-01', 3, 'March', 1, 2023),
('2023-04-01', 4, 'April', 2, 2023),
('2023-05-01', 5, 'May', 2, 2023),
('2023-06-01', 6, 'June', 2, 2023),
('2023-07-01', 7, 'July', 3, 2023),
('2023-08-01', 8, 'August', 3, 2023),
('2023-09-01', 9, 'September', 3, 2023),
('2023-10-01', 10, 'October', 4, 2023),
('2023-11-01', 11, 'November', 4, 2023),
('2023-12-01', 12, 'December', 4, 2023);

INSERT INTO DimOrder (OrderQuantity, CustomerType, Revenue)
SELECT 
    Order_quantities,
    Customer_demographics,
	Revenue_generated 
FROM supply_chain_data;

INSERT INTO FactShipments (ShippingDays, ShippingCosts, TotalCosts, ProductID, SupplierID, WarehouseID, OrderID, TimeID)
SELECT 
    Shipping_times,
    Shipping_costs,
    Costs,
    p.ProductID,
    s.SupplierID,
    w.WarehouseID,
    o.OrderID,
    t.TimeID
FROM supply_chain_data sc
JOIN DimProducts p ON sc.SKU = p.ProductCode
JOIN Dimsupplier s ON sc.Supplier_name = s.Suppliername
JOIN DimWarehouse w ON sc.Routes = w.RouteName
JOIN DimOrder o ON sc.Order_quantities = o.OrderQuantity
CROSS JOIN (SELECT TOP 1 TimeID FROM DimTime) t;

SELECT * FROM FactShipments;