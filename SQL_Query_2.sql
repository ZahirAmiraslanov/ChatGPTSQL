WITH QuarterlySales AS (
  SELECT
    SI.[Stock Item] AS [ProductName],
    DATEPART(YEAR, S.[Invoice Date Key]) AS [Year],
    DATEPART(QUARTER, S.[Invoice Date Key]) AS [Quarter],
    SUM(S.[Total Excluding Tax]) AS [TotalRevenue],
    SUM(S.[Quantity]) AS [TotalQuantity]
  FROM
    [Fact].[Sale] S
    INNER JOIN [Dimension].[Stock Item] SI ON S.[Stock Item Key] = SI.[Stock Item Key]
  GROUP BY
    SI.[Stock Item],
    DATEPART(YEAR, S.[Invoice Date Key]),
    DATEPART(QUARTER, S.[Invoice Date Key])
)
SELECT
  Q1.[ProductName],
  (Q1.[TotalRevenue] / Q2.[TotalRevenue] - 1) * 100 AS [GrowthRevenueRate],
  (Q1.[TotalQuantity] / Q2.[TotalQuantity] - 1) * 100 AS [GrowthQuantityRate],
  Q1.[Year] AS [CurrentYear],
  Q1.[Quarter] AS [CurrentQuarter],
  --Q1.[TotalRevenue] AS [CurrentQuarterRevenue],
  --Q1.[TotalQuantity] AS [CurrentQuarterQuantity],
  Q2.[Year] AS [PreviousYear],
  Q2.[Quarter] AS [PreviousQuarter]
  --Q2.[TotalRevenue] AS [PreviousQuarterRevenue],
  --Q2.[TotalQuantity] AS [PreviousQuarterQuantity],
FROM
  QuarterlySales Q1
  LEFT JOIN QuarterlySales Q2 ON Q1.[ProductName] = Q2.[ProductName] AND Q1.[Year] = Q2.[Year] + 1 AND Q1.[Quarter] = Q2.[Quarter]
ORDER BY
  
  Q1.[Year],
  Q1.[Quarter],
  Q1.[ProductName];



