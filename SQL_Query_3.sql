

-- Retrieve sales revenue and quantity contributions by customer as a percentage of total sales revenue and quantity for each quarter and year

SELECT
    c.Customer AS CustomerName,
    -- Calculate the percentage of total revenue contributed by the customer for each quarter and year
    (SUM(fs.[Unit Price] * fs.Quantity) / CAST(total_sales_revenue.TotalRevenue AS DECIMAL(18, 2))) * 100 AS TotalRevenuePercentage,
    -- Calculate the percentage of total quantity contributed by the customer for each quarter and year
    (SUM(fs.Quantity) / CAST(total_sales_quantity.TotalQuantity AS DECIMAL(18, 2))) * 100 AS TotalQuantityPercentage,
    -- Extract the quarter from the invoice date
    DATEPART(QUARTER, fs.[Invoice Date Key]) AS Quarter,
    -- Extract the year from the invoice date
    DATEPART(YEAR, fs.[Invoice Date Key]) AS Year
FROM
    Dimension.Customer c
JOIN
    Fact.Sale fs ON c.[Customer Key] = fs.[Customer Key]
JOIN
    (
        -- Calculate the total revenue for each quarter and year
        SELECT
            DATEPART(QUARTER, [Invoice Date Key]) AS Quarter,
            DATEPART(YEAR, [Invoice Date Key]) AS Year,
            SUM([Unit Price] * Quantity) AS TotalRevenue
        FROM
            Fact.Sale
        GROUP BY
            DATEPART(QUARTER, [Invoice Date Key]),
            DATEPART(YEAR, [Invoice Date Key])
    ) total_sales_revenue ON DATEPART(QUARTER, fs.[Invoice Date Key]) = total_sales_revenue.Quarter AND DATEPART(YEAR, fs.[Invoice Date Key]) = total_sales_revenue.Year
JOIN
    (
        -- Calculate the total quantity for each quarter and year
        SELECT
            DATEPART(QUARTER, [Invoice Date Key]) AS Quarter,
            DATEPART(YEAR, [Invoice Date Key]) AS Year,
            SUM(Quantity) AS TotalQuantity
        FROM
            Fact.Sale
        GROUP BY
            DATEPART(QUARTER, [Invoice Date Key]),
            DATEPART(YEAR, [Invoice Date Key])
    ) total_sales_quantity ON DATEPART(QUARTER, fs.[Invoice Date Key]) = total_sales_quantity.Quarter AND DATEPART(YEAR, fs.[Invoice Date Key]) = total_sales_quantity.Year
GROUP BY
    c.Customer,
    DATEPART(QUARTER, fs.[Invoice Date Key]),
    DATEPART(YEAR, fs.[Invoice Date Key]),
    total_sales_revenue.TotalRevenue,
    total_sales_quantity.TotalQuantity
ORDER BY
    Year, Quarter;
