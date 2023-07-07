
SELECT
    si.[Stock Item] AS ProductName,
    (CAST((fs.Quantity * fs.[Unit Price]) AS FLOAT) - 
        LAG((fs.Quantity * fs.[Unit Price])) OVER (ORDER BY YEAR([Invoice Date Key]), DATEPART(QUARTER, [Invoice Date Key]))) / 
        LAG((fs.Quantity * fs.[Unit Price])) OVER (ORDER BY YEAR([Invoice Date Key]), DATEPART(QUARTER, [Invoice Date Key])) * 100 AS GrowthRevenueRate,
    (CAST(fs.Quantity AS FLOAT) - 
        LAG(fs.Quantity) OVER (ORDER BY YEAR([Invoice Date Key]), DATEPART(QUARTER, [Invoice Date Key]))) / 
        LAG(fs.Quantity) OVER (ORDER BY YEAR([Invoice Date Key]), DATEPART(QUARTER, [Invoice Date Key])) * 100 AS GrowthQuantityRate,
    DATEPART(QUARTER, '2016-01-01') AS CurrentQuarter,
    2016 AS CurrentYear,
    DATEPART(QUARTER, DATEADD(QUARTER, -1, '2016-01-01')) AS PreviousQuarter,
    2015 AS PreviousYear
FROM Dimension.[Stock Item] si
JOIN Fact.Sale fs ON si.[Stock Item Key] = fs.[Stock Item Key]
