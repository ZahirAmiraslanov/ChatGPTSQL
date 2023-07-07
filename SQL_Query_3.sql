WITH QuarterlySales AS (
    SELECT
        c.[Customer] AS CustomerName,
        DATEPART(QUARTER, s.[Invoice Date Key]) AS Quarter,
        DATEPART(YEAR, s.[Invoice Date Key]) AS Year,
        SUM(s.[Total Excluding Tax]) AS QuarterlyRevenue,
        SUM(s.[Quantity]) AS QuarterlyQuantity
    FROM
        [Fact].[Sale] s
        INNER JOIN [Dimension].[Customer] c ON s.[Customer Key] = c.[Customer Key]
    GROUP BY
        c.[Customer],
        DATEPART(QUARTER, s.[Invoice Date Key]),
        DATEPART(YEAR, s.[Invoice Date Key])
),
TotalSales AS (
    SELECT
        DATEPART(QUARTER, s.[Invoice Date Key]) AS Quarter,
        DATEPART(YEAR, s.[Invoice Date Key]) AS Year,
        SUM(s.[Total Excluding Tax]) AS TotalRevenue,
        SUM(s.[Quantity]) AS TotalQuantity
    FROM
        [Fact].[Sale] s
    GROUP BY
        DATEPART(QUARTER, s.[Invoice Date Key]),
        DATEPART(YEAR, s.[Invoice Date Key])
)
SELECT
    qs.CustomerName,
    qs.Quarter,
    qs.Year,
    (qs.QuarterlyRevenue / CAST(ts.TotalRevenue AS decimal)) * 100 AS TotalRevenuePercentage,
    (qs.QuarterlyQuantity / CAST(ts.TotalQuantity AS decimal)) * 100 AS TotalQuantityPercentage
FROM
    QuarterlySales qs
    INNER JOIN TotalSales ts ON qs.Quarter = ts.Quarter AND qs.Year = ts.Year
ORDER BY
    qs.CustomerName,
    qs.Quarter,
    qs.Year;
