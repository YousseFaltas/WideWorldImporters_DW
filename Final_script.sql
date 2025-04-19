USE [master]
GO
/****** Object:  Database [WWI_DW]    Script Date: 4/15/2025 12:40:23 AM ******/
CREATE DATABASE [WWI_DW]
 CONTAINMENT = NONE
 ON  PRIMARY 
 --change the filename path to your local path
( NAME = N'WWI_DW', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\WWI_DW.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'WWI_DW_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\WWI_DW_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [WWI_DW] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [WWI_DW].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [WWI_DW] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [WWI_DW] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [WWI_DW] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [WWI_DW] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [WWI_DW] SET ARITHABORT OFF 
GO
ALTER DATABASE [WWI_DW] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [WWI_DW] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [WWI_DW] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [WWI_DW] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [WWI_DW] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [WWI_DW] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [WWI_DW] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [WWI_DW] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [WWI_DW] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [WWI_DW] SET  ENABLE_BROKER 
GO
ALTER DATABASE [WWI_DW] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [WWI_DW] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [WWI_DW] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [WWI_DW] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [WWI_DW] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [WWI_DW] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [WWI_DW] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [WWI_DW] SET RECOVERY FULL 
GO
ALTER DATABASE [WWI_DW] SET  MULTI_USER 
GO
ALTER DATABASE [WWI_DW] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [WWI_DW] SET DB_CHAINING OFF 
GO
ALTER DATABASE [WWI_DW] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [WWI_DW] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [WWI_DW] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [WWI_DW] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'WWI_DW', N'ON'
GO
ALTER DATABASE [WWI_DW] SET QUERY_STORE = ON
GO
ALTER DATABASE [WWI_DW] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [WWI_DW]
GO
/****** Object:  Table [dbo].[DimCustomer]    Script Date: 4/15/2025 12:40:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimCustomer](
	[CustomerKey] [int] IDENTITY(1,1) NOT NULL,
	[WWICustomerID] [int] NOT NULL,
	[CustomerName] [nvarchar](100) NOT NULL,
	[CustomerCategoryName] [nvarchar](50) NULL,
	[BuyingGroupName] [nvarchar](50) NULL,
	[DeliveryMethodName] [nvarchar](50) NULL,
	[CityName] [nvarchar](50) NULL,
	[PhoneNumber] [nvarchar](20) NULL,
	[DeliveryAddressLine1] [nvarchar](60) NULL,
	[DeliveryAddressLine2] [nvarchar](60) NULL,
PRIMARY KEY CLUSTERED 
(
	[CustomerKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DimDate]    Script Date: 4/15/2025 12:40:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimDate](
	[DateKey] [int] NOT NULL,
	[DateValue] [date] NULL,
	[DayNumber] [int] NULL,
	[CalendarMonthNumber] [int] NULL,
	[CalendarYear] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[DateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[DateValue] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DimPurchasingOrderLine]    Script Date: 4/15/2025 12:40:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimPurchasingOrderLine](
	[PurchasingOrderDimID] [int] IDENTITY(1,1) NOT NULL,
	[WWI_PurchasingOrderID] [int] NOT NULL,
	[SupplierID] [int] NOT NULL,
	[OrderDate] [date] NOT NULL,
	[ExpectedDeliveryDate] [date] NOT NULL,
	[DeliveryMethodName] [nvarchar](50) NULL,
	[StockItemID] [int] NOT NULL,
	[PackageTypeName] [int] NOT NULL,
	[OrderOuters] [int] NOT NULL,
	[ReceivedOuters] [int] NOT NULL,
	[ExpectedUnitPrice] [decimal](18, 2) NOT NULL,
	[LastReceiptDate] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[PurchasingOrderDimID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DimSellingOrderLine]    Script Date: 4/15/2025 12:40:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON

GO
/****** Object:  Table [dbo].[DimStockItem]    Script Date: 4/15/2025 12:40:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimStockItem](
	[StockItemKey] [int] IDENTITY(1,1) NOT NULL,
	[StockItemID] [int] NULL,
	[StockItemName] [nvarchar](100) NULL,
	[Brand] [nvarchar](50) NULL,
	[Size] [nvarchar](20) NULL,
	[Barcode] [nvarchar](50) NULL,
	[UnitPackageName] [nvarchar](50) NULL,
	[OuterPackageName] [nvarchar](50) NULL,
	[IsChillerStock] [bit] NULL,
	[ColorName] [nvarchar](20) NULL,
	[SupplierID] [int] NULL,
	[LeadTimeDays] [int] NULL,
	[QuantityPerOuter] [int] NULL,
	[TaxRate] [decimal](18, 3) NULL,
	[UnitPrice] [decimal](18, 2) NULL,
	[RecommendedRetailPrice] [decimal](18, 2) NULL,
	[TypicalWeightPerUnit] [decimal](18, 3) NULL,
PRIMARY KEY CLUSTERED 
(
	[StockItemKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DimSupplier]    Script Date: 4/15/2025 12:40:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimSupplier](
	[SupplierKey] [int] IDENTITY(1,1) NOT NULL,
	[WWISupplierID] [int] NULL,
	[SupplierName] [nvarchar](100) NULL,
	[SupplierCategoryName] [nvarchar](50) NULL,
	[PhoneNumber] [nvarchar](20) NULL,
	[WebsiteURL] [nvarchar](256) NULL,
	[SupplierReference] [nvarchar](20) NULL,
	[PaymentDays] [int] NULL,
	[DeliveryMethodName] [nvarchar](50) NULL,
	[CityName] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[SupplierKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FactInventoryMovement]    Script Date: 4/15/2025 12:40:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactInventoryMovement](
--The date dimension FK
	[POrderDateKey] [int] NOT NULL,
	[POrderExpectedDelDateKey] [int] NOT NULL,
	[ItemLReceiptDateKey] [int] NOT NULL,
	[StockReceiptDateKey] [int] NOT NULL,

--FK for other Dimensions
	[StockItemKey] [int] NOT NULL,
	[PurchasingOrderKey] [int] NOT NULL,
	[SupplierKey] [int] NOT NULL,
	[WarehouseTransactionDimID] [int] NOT NULL,

--fact Table Measures
	[QuantityOutersOrdered] [int] NULL,--Amount of stock Ordered From supplier
	[QuantityOutersReceived] [int] NULL,--Amount of Stock Successfully received from suppliers
	[QuantityItemsReceived] [int] NULL,
	[QuantityStored] [int] NULL,--Amount of Stock stored in the warehouse
	[LeadTimeDays] [int] NULL,--Days between order placement and receipt

PRIMARY KEY CLUSTERED 
(
	[POrderDateKey] ASC,
	[POrderExpectedDelDateKey] ASC,
	[ItemLReceiptDateKey] ASC,
	[StockReceiptDateKey] ASC,
	[StockItemKey] ASC,
	[PurchasingOrderKey] ASC,
	[SupplierKey] ASC,
	[WarehouseTransactionDimID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WarehouseTransactionDim]    Script Date: 4/15/2025 12:40:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WarehouseTransactionDim](
	[WarehouseTransactionDimID] [int] IDENTITY(1,1) NOT NULL,
	[WWIStockItemTransactionID] [int] NOT NULL,
	[StockItemID] [int] NOT NULL,
	[TransactionTypeName] [nvarchar](50) NOT NULL,
	[TransactionOccurredWhen] [datetime2](7) NOT NULL,
	[Quantity] [decimal](18, 3) NOT NULL,
	[CustomerID] [int] NULL,
	[SupplierID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[WarehouseTransactionDimID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FactInventoryMovement]  WITH CHECK ADD FOREIGN KEY([ItemLReceiptDateKey])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [dbo].[FactInventoryMovement]  WITH CHECK ADD FOREIGN KEY([POrderDateKey])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [dbo].[FactInventoryMovement]  WITH CHECK ADD FOREIGN KEY([POrderExpectedDelDateKey])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [dbo].[FactInventoryMovement]  WITH CHECK ADD FOREIGN KEY([PurchasingOrderKey])
REFERENCES [dbo].[DimPurchasingOrderLine] ([PurchasingOrderDimID])
GO
ALTER TABLE [dbo].[FactInventoryMovement]  WITH CHECK ADD FOREIGN KEY([StockReceiptDateKey])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [dbo].[FactInventoryMovement]  WITH CHECK ADD FOREIGN KEY([StockItemKey])
REFERENCES [dbo].[DimStockItem] ([StockItemKey])
GO
ALTER TABLE [dbo].[FactInventoryMovement]  WITH CHECK ADD FOREIGN KEY([SupplierKey])
REFERENCES [dbo].[DimSupplier] ([SupplierKey])
GO
ALTER TABLE [dbo].[FactInventoryMovement]  WITH CHECK ADD FOREIGN KEY([WarehouseTransactionDimID])
REFERENCES [dbo].[WarehouseTransactionDim] ([WarehouseTransactionDimID])
GO
USE [master]
GO
ALTER DATABASE [WWI_DW] SET  READ_WRITE 
GO
