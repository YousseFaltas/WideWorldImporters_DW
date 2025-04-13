CREATE DATABASE WWI_DW;

GO
USE WWI_DW;
GO

-- Dimension Table: Customer
CREATE TABLE DimCustomer (
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY,  -- Surrogate key
    WWICustomerID INT NOT NULL,  -- Business key from OLTP
    CustomerName NVARCHAR(100) NOT NULL,
    CustomerCategoryName NVARCHAR(50),  -- Derived from CustomerCategoryID
    BuyingGroupName NVARCHAR(50),  -- Derived from BuyingGroupID
    DeliveryMethodName NVARCHAR(50),  -- Standard delivery method
    CityName NVARCHAR(50),  -- City name instead of ID
    PhoneNumber NVARCHAR(20),
    DeliveryAddressLine1 NVARCHAR(60),  -- Combined address lines
	DeliveryAddressLine2 NVARCHAR(60)  -- Combined address lines
);
GO

-- Dimension Table: Supplier
CREATE TABLE DimSupplier (
    SupplierKey INT PRIMARY KEY,-- Surrogate Key
    WWISupplierID INT UNIQUE,-- Business Key
    SupplierName NVARCHAR(100),
    SupplierCategoryName  NVARCHAR(50),
    PhoneNumber NVARCHAR(20),
	WebsiteURL NVARCHAR(256),
    SupplierReference NVARCHAR(20),
    PaymentDays INT,
	DeliveryMethodName NVARCHAR(50),  -- Standard delivery method
    CityName NVARCHAR(50),  -- City name instead of ID
);
GO

CREATE TABLE DimStockItem (
    StockItemKey INT PRIMARY KEY,  -- Surrogate Key
    StockItemID INT,  -- Business Key
    StockItemName NVARCHAR(100),
    Brand NVARCHAR(50),
    Size NVARCHAR(20),
    Barcode NVARCHAR(50),
    UnitPackageName NVARCHAR(50),
    OuterPackageName NVARCHAR(50),
    IsChillerStock BIT,
    ColorName NVARCHAR(20) NULL,
    SupplierID INT NULL,
    LeadTimeDays INT NULL,
    QuantityPerOuter INT NULL,
    TaxRate DECIMAL(18,3),
    UnitPrice DECIMAL(18,2),
    RecommendedRetailPrice DECIMAL(18,2),
    TypicalWeightPerUnit DECIMAL(18,3)
);
GO

-- Dimension Table: SellingOrders
CREATE TABLE DimSellingOrderLine (
    SellingOrderKey INT IDENTITY(1,1) PRIMARY KEY,  -- Surrogate key for the dimension
    CustomerID INT NOT NULL,  -- Foreign key to the Customer table
    OrderDate DATE NOT NULL,  -- Date when the order was raised
    ExpectedDeliveryDate DATE NULL,  -- Expected delivery date (nullable)
    CustomerPurchaseOrderNumber NVARCHAR(20) NOT NULL,  -- Purchase order number received from the customer
    StockItemID INT NOT NULL,  -- Foreign key to the StockItems table
    PackageTypeName NVARCHAR(50) NOT NULL,  -- Foreign key to the PackageTypes table
    Quantity INT NOT NULL,  -- Quantity to be supplied for this order line
    UnitPrice DECIMAL(18, 2) NOT NULL,  -- Unit price to be charged
    PickedQuantity INT NOT NULL,  -- Quantity picked from stock
    PickingCompletedWhen DATETIME2(7) NULL,  -- Date and time when picking was completed
);

GO

-- Dimension Table: PurchasingOrders
CREATE TABLE DimPurchasingOrderLine (
    PurchasingOrderDimID INT PRIMARY KEY IDENTITY(1,1), -- Unique identifier for the dimension record
    SupplierID INT NOT NULL, -- Supplier ID (foreign key to the Suppliers dimension)
    OrderDate DATE NOT NULL, -- Order date for the purchase order
    ExpectedDeliveryDate DATE NOT NULL, -- Expected delivery date
    DeliveryMethodName NVARCHAR(50) NULL, -- Delivery method for the purchased items
    StockItemID INT NOT NULL, -- Stock item ID (foreign key to the StockItems dimension)
    PackageTypeName INT NOT NULL, -- Package type for outers (foreign key to the PackageTypes dimension)
    OrderOuters INT NOT NULL, -- Number of outers ordered
    ReceivedOuters INT NOT NULL, -- Number of outers received
    ExpectedUnitPrice DECIMAL(18, 2) NOT NULL, -- Expected unit price of the stock item
    LastReceiptDate DATE NULL, -- The last date when this stock item was received
);

GO

-- Dimension Table: Date


CREATE TABLE DimDate (
    DateKey INT PRIMARY KEY,
    DateValue DATE UNIQUE,
    DayNumber INT,
    Day VARCHAR(10),
    Month VARCHAR(15),
    ShortMonth CHAR(3),
    CalendarMonthNumber INT,
    CalendarYear INT,
);
GO

CREATE TABLE WarehouseTransactionDim (
    WarehouseTransactionDimID INT PRIMARY KEY IDENTITY(1,1),  -- Surrogate key for the dimension
    WWIStockItemTransactionID INT NOT NULL,  -- Unique transaction ID
    StockItemID INT NOT NULL,  -- The stock item being moved
    TransactionTypeName NVARCHAR(50) NOT NULL,  -- Type of transaction (purchase, sale, return, etc.)
    TransactionOccurredWhen DATETIME2(7) NOT NULL,  -- Date and time of transaction
    Quantity DECIMAL(18, 3) NOT NULL,  -- Quantity of stock movement (positive for incoming, negative for outgoing)
    CustomerID INT NULL,  -- Nullable: if applicable, customer ID for sales or returns
    SupplierID INT NULL  -- Nullable: if applicable, supplier ID for purchases or replenishments
);
GO

-- Fact Table: Inventory Transactions
CREATE TABLE FactInventoryMovement (
    -- Foreign keys to the role-playing date dimension
    POrderDateKey INT, 
    POrderExpectedDelDateKey INT, 
    ItemLReceiptDateKey INT, 
    StockReceiptDateKey INT,  
    SOrderDateKey INT, 
    SOrderExpectedDelDateKey INT,
    StockIssueDateKey INT,
    ItemSoldDelDateKey INT,

    -- Foreign keys to dimension tables
    StockItemKey INT NOT NULL,
    SellingOrderKey INT,
    PurchasingOrderKey INT,
    CustomerKey INT,
    SupplierKey INT,
    WarehouseTransactionDimID INT,

    -- Measures
    QuantityOrdered INT,
    QuantityReceived INT,
    QuantityStored INT,
    QuantityDispatched INT,
    DaysInWarehouse INT,
    LeadTimeDays INT,

    -- Composite Primary Key
    PRIMARY KEY (
        POrderDateKey,
        POrderExpectedDelDateKey,
        ItemLReceiptDateKey,
        StockReceiptDateKey,
        SOrderDateKey,
        SOrderExpectedDelDateKey,
        StockIssueDateKey,
        ItemSoldDelDateKey,
        StockItemKey,
        SellingOrderKey,
        PurchasingOrderKey,
        CustomerKey,
        SupplierKey,
        WarehouseTransactionDimID
    ),

    -- Foreign key constraints
    FOREIGN KEY (POrderDateKey) REFERENCES DimDate(DateKey),
    FOREIGN KEY (POrderExpectedDelDateKey) REFERENCES DimDate(DateKey),
    FOREIGN KEY (ItemLReceiptDateKey) REFERENCES DimDate(DateKey),
    FOREIGN KEY (StockReceiptDateKey) REFERENCES DimDate(DateKey),
    FOREIGN KEY (SOrderDateKey) REFERENCES DimDate(DateKey),
    FOREIGN KEY (SOrderExpectedDelDateKey) REFERENCES DimDate(DateKey),
    FOREIGN KEY (StockIssueDateKey) REFERENCES DimDate(DateKey),
    FOREIGN KEY (ItemSoldDelDateKey) REFERENCES DimDate(DateKey),
    FOREIGN KEY (StockItemKey) REFERENCES DimStockItem(StockItemKey),
    FOREIGN KEY (SellingOrderKey) REFERENCES DimSellingOrderLine(SellingOrderKey),
    FOREIGN KEY (PurchasingOrderKey) REFERENCES DimPurchasingOrderLine(PurchasingOrderDimID),
    FOREIGN KEY (CustomerKey) REFERENCES DimCustomer(CustomerKey),
    FOREIGN KEY (SupplierKey) REFERENCES DimSupplier(SupplierKey),
    FOREIGN KEY (WarehouseTransactionDimID) REFERENCES WarehouseTransactionDim(WarehouseTransactionDimID)
);
GO

GO
