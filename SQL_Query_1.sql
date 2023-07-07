
  SELECT DISTINCT TOP 10
			si.[Stock Item] as ProductName,
			fs.Quantity,
			fs.Quantity*fs.[Unit Price] as Revenue,
			YEAR([Invoice Date Key]) AS sales_year,
			DATEPART(QUARTER, [Invoice Date Key] ) AS sales_quarter
			
  FROM Dimension.[Stock Item] si
  JOIN Fact.Sale fs ON si.[Stock Item Key]=fs.[Stock Item Key]
  ORDER BY Revenue desc


SELECT DISTINCT TOP 10
    si.[Stock Item] AS ProductName,
    fs.Quantity,
    fs.Quantity * fs.[Unit Price] AS Revenue,
    YEAR([Invoice Date Key]) AS sales_year,
    DATEPART(QUARTER, [Invoice Date Key]) AS sales_quarter,
    SUM(fs.Quantity) OVER (PARTITION BY si.[Stock Item], YEAR([Invoice Date Key]), DATEPART(QUARTER, [Invoice Date Key])) AS QuarterQuantity,
    SUM(fs.Quantity * fs.[Unit Price]) OVER (PARTITION BY si.[Stock Item], YEAR([Invoice Date Key]), DATEPART(QUARTER, [Invoice Date Key])) AS QuarterRevenue,
    SUM(fs.Quantity) OVER (PARTITION BY si.[Stock Item], YEAR([Invoice Date Key])) AS YearQuantity,
    SUM(fs.Quantity * fs.[Unit Price]) OVER (PARTITION BY si.[Stock Item], YEAR([Invoice Date Key])) AS YearRevenue
FROM Dimension.[Stock Item] si
JOIN Fact.Sale fs ON si.[Stock Item Key] = fs.[Stock Item Key]
ORDER BY Revenue DESC;



SELECT TOP 10
    ProductName,
    Quantity as SalesQuantity,
    Revenue as SalesRevenue,
    SUM(Quantity) OVER (PARTITION BY sales_year, sales_quarter, ProductName) AS QuarterQuantity,
    SUM(Revenue) OVER (PARTITION BY sales_year, sales_quarter, ProductName) AS QuarterRevenue,
    SUM(Quantity) OVER (PARTITION BY sales_year, ProductName) AS YearQuantity,
    SUM(Revenue) OVER (PARTITION BY sales_year, ProductName) AS YearRevenue
FROM (
    SELECT
        si.[Stock Item] AS ProductName,
        fs.Quantity,
        fs.Quantity * fs.[Unit Price] AS Revenue,
        YEAR([Invoice Date Key]) AS sales_year,
        DATEPART(QUARTER, [Invoice Date Key]) AS sales_quarter,
        ROW_NUMBER() OVER (PARTITION BY si.[Stock Item] ORDER BY fs.Quantity * fs.[Unit Price] DESC) AS rn
    FROM Dimension.[Stock Item] si
    JOIN Fact.Sale fs ON si.[Stock Item Key] = fs.[Stock Item Key]
) AS subquery
WHERE rn = 1
ORDER BY Revenue DESC;























  Select * from [Fact].[Purchase]

  select * from Fact.Sale