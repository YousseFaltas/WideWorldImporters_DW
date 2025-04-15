SELECT 
    sit.StockItemTransactionID AS WWIStockItemTransactionID,
    sit.StockItemID,
    tt.TransactionTypeName,
    sit.TransactionOccurredWhen,
    sit.Quantity,
    sit.CustomerID,
    sit.SupplierID
FROM 
    Warehouse.StockItemTransactions sit
JOIN 
    Application.TransactionTypes tt ON sit.TransactionTypeID = tt.TransactionTypeID;