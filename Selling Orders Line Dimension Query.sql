SELECT 
    o.CustomerID,
    o.OrderDate,
    o.ExpectedDeliveryDate,
    o.CustomerPurchaseOrderNumber,
    ol.StockItemID,
    pt.PackageTypeName,
    ol.Quantity,
    ol.UnitPrice,
    ol.PickedQuantity,
    ol.PickingCompletedWhen
FROM 
    Sales.Orders o
JOIN 
    Sales.OrderLines ol ON o.OrderID = ol.OrderID
JOIN 
    Warehouse.StockItems si ON ol.StockItemID = si.StockItemID
JOIN 
    Warehouse.PackageTypes pt ON ol.PackageTypeID = pt.PackageTypeID;