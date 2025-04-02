CREATE DATABASE WWI_DW;

GO
USE WWI_DW;
GO

-- Dimension Table: Date
CREATE TABLE DimensionDate (
    DateKey INT PRIMARY KEY,
    DateValue DATE UNIQUE,
    DayNumber INT,
    Day VARCHAR(10),
    Month VARCHAR(15),
    ShortMonth CHAR(3),
    CalendarMonthNumber INT,
    CalendarMonthLabel VARCHAR(20),
    CalendarYear INT,
    CalendarYearLabel VARCHAR(10)
);
GO

-- Dimension Table: Customer
CREATE TABLE DimensionCustomer (
    CustomerKey INT PRIMARY KEY IDENTITY(1,1),
    WWICustomerID INT UNIQUE,
    Customer VARCHAR(255),
    BillToCustomer VARCHAR(255),
    Category VARCHAR(50),
    BuyingGroup VARCHAR(50),
    PrimaryContact VARCHAR(255)
);
GO

-- Dimension Table: Supplier
CREATE TABLE DimensionSupplier (
    SupplierKey INT PRIMARY KEY IDENTITY(1,1),
    WWISupplierID INT UNIQUE,
    Supplier VARCHAR(255),
    Category VARCHAR(50),
    PrimaryContact VARCHAR(255),
    SupplierReference VARCHAR(100),
    PaymentDays INT,
    DeliveryMethodID INT 
);
GO

-- Dimension Table: StockItem
CREATE TABLE DimensionStockItem (
    StockItemKey INT PRIMARY KEY IDENTITY(1,1),
    StockItemID INT UNIQUE,
    StockItemName VARCHAR(255),
    Color VARCHAR(50),
    SellingPackage VARCHAR(100),
    BuyingPackage VARCHAR(100),
    Brand VARCHAR(100),
    Size VARCHAR(50),
    QuantityPerOuter INT,
    Barcode VARCHAR(50),
    TaxRate DECIMAL(5,2),
    UnitPrice DECIMAL(10,2),
    TypicalWeight DECIMAL(10,2)
);
GO

-- Dimension Table: SellingOrders
CREATE TABLE DimensionSellingOrders (
    SellingOrderKey INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT UNIQUE,
    OrderNumber VARCHAR(50),
    PackageType VARCHAR(50),
    PickedQuantity INT
);
GO

-- Dimension Table: PurchasingOrders
CREATE TABLE DimensionPurchasingOrders (
    PurchasingOrderKey INT PRIMARY KEY IDENTITY(1,1),
    PurchaseOrderID INT UNIQUE,
    DeliveryMethod VARCHAR(50),
    IsOrderFinalized BIT,
    QuantityOrderOuters INT,
    ReceivedOuters INT,
    ExpectedUnitPrice DECIMAL(10,2),
    PerOuter DECIMAL(10,2)
);
GO

-- Fact Table: Inventory Transactions
CREATE TABLE FactInventoryMovement (
    --The Row Key
	FactID INT PRIMARY KEY IDENTITY(1,1),

	--The Foreign keys of the role playing date dimension
	PurchasingDateKey INT, 
    LastReceiptDateKey INT, 
    PurchasingExpectedKey INT, 
    DeliveryDateKey INT, 
    FinishedInventoryPlacementDateKey INT, 
    InvoiceDateKey INT, 
    OrderDateKey INT, 
    ExpectedDeliveryDateKey INT, 
    ActualDeliveryDateKey INT,
	FOREIGN KEY (PurchasingDateKey) REFERENCES DimensionDate(DateKey),
    FOREIGN KEY (LastReceiptDateKey) REFERENCES DimensionDate(DateKey),
    FOREIGN KEY (PurchasingExpectedKey) REFERENCES DimensionDate(DateKey),
    FOREIGN KEY (DeliveryDateKey) REFERENCES DimensionDate(DateKey),
    FOREIGN KEY (FinishedInventoryPlacementDateKey) REFERENCES DimensionDate(DateKey),
    FOREIGN KEY (InvoiceDateKey) REFERENCES DimensionDate(DateKey),
    FOREIGN KEY (OrderDateKey) REFERENCES DimensionDate(DateKey),
    FOREIGN KEY (ExpectedDeliveryDateKey) REFERENCES DimensionDate(DateKey),
    FOREIGN KEY (ActualDeliveryDateKey) REFERENCES DimensionDate(DateKey),

	--Foreign keys for the rest of the dimesnions
	StockItemKey INT NOT NULL,
    SellingOrderKey INT,
    PurchasingOrderKey INT,
    CustomerKey INT,
    SupplierKey INT,
	FOREIGN KEY (StockItemKey) REFERENCES DimensionStockItem(StockItemKey),
    FOREIGN KEY (SellingOrderKey) REFERENCES DimensionSellingOrders(SellingOrderKey),
    FOREIGN KEY (PurchasingOrderKey) REFERENCES DimensionPurchasingOrders(PurchasingOrderKey),
    FOREIGN KEY (CustomerKey) REFERENCES DimensionCustomer(CustomerKey),
    FOREIGN KEY (SupplierKey) REFERENCES DimensionSupplier(SupplierKey),
	
	--The created measures useful in tracking the items
    QuantityOrdered INT,
    QuantityReceived INT,
    QuantityStored INT,
    QuantityDispatched INT,
    QuantityReturned INT,
    DaysInWarehouse INT,
    LeadTimeDays INT,
);
GO
