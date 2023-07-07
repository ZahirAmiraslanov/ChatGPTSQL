WITH QuarterlySales AS (
    SELECT
        s.[Stock Item Key],
        SUM(s.[Total Including Tax]) AS SalesRevenue,
        SUM(s.[Quantity]) AS SalesQuantity,
        DATEPART(QUARTER, d.[Date]) AS Quarter,
        DATEPART(YEAR, d.[Date]) AS Year,
        ROW_NUMBER() OVER (PARTITION BY DATEPART(QUARTER, d.[Date]), DATEPART(YEAR, d.[Date]) ORDER BY SUM(s.[Total Including Tax]) DESC) AS Rank
    FROM
        [Fact].[Sale] s
        JOIN [Dimension].[Date] d ON s.[Invoice Date Key] = d.[Date]
    GROUP BY
        s.[Stock Item Key],
        DATEPART(QUARTER, d.[Date]),
        DATEPART(YEAR, d.[Date])
)
SELECT
    si.[Stock Item] AS ProductName,
    qs.SalesQuantity,
    qs.SalesRevenue,
    qs.Quarter,
    qs.Year
FROM
    QuarterlySales qs
    JOIN [Dimension].[Stock Item] si ON qs.[Stock Item Key] = si.[Stock Item Key]
WHERE
    qs.Rank <= 10
ORDER BY
    qs.Year,
    qs.Quarter,
    qs.Rank