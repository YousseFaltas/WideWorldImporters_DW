SELECT 
    -- Surrogate key (to be generated in the data warehouse)
    S.SupplierID AS WWISupplierID,  -- Natural Key

    -- Supplier details
    S.SupplierName,

    -- Lookup for Supplier Category
    SC.SupplierCategoryName AS Category,

    -- Contact information
    S.PhoneNumber,
    S.WebsiteURL,

    -- Reference & Payment Terms
    S.SupplierReference,
    S.PaymentDays,

    -- Delivery Method
    DM.DeliveryMethodName AS DeliveryMethod,

    -- Delivery & Postal City (Joining with Cities table for readable names)
    DC.CityName AS DeliveryCity,
    PC.CityName AS PostalCity

FROM WideWorldImporters.Purchasing.Suppliers S

-- Joining with Supplier Categories to get category name
LEFT JOIN WideWorldImporters.Purchasing.SupplierCategories SC 
    ON S.SupplierCategoryID = SC.SupplierCategoryID

-- Joining with Delivery Methods to get method name
LEFT JOIN WideWorldImporters.Application.DeliveryMethods DM 
    ON S.DeliveryMethodID = DM.DeliveryMethodID

-- Joining with Cities table for Delivery City Name
LEFT JOIN WideWorldImporters.Application.Cities DC 
    ON S.DeliveryCityID = DC.CityID

-- Joining with Cities table for Postal City Name
LEFT JOIN WideWorldImporters.Application.Cities PC 
    ON S.PostalCityID = PC.CityID;
