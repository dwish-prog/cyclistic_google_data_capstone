-- Compare Months

WITH MonthlyMetrics AS(
	SELECT
		[ride_month] AS [Month],
		SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS [Casual Trips],
		SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS [Member Trips],
		COUNT(*) AS [Total Trips]
	FROM all_trips_master
	GROUP BY ride_month
)
SELECT
	[Month],
	[Casual Trips],
	ROUND([Casual Trips] * 100.0 / SUM([Casual Trips]) OVER(), 2) AS [Casual Proportion (%)],
	[Member Trips],
	ROUND([Member Trips] * 100.0 / SUM([Member Trips]) OVER(), 2) AS [Member Proportion (%)],
	[Total Trips],
	ROUND([Total Trips] * 100.0 / SUM([Total Trips]) OVER(), 2) AS [Overall Dataset Average (%)]
FROM MonthlyMetrics
ORDER BY Month;


-- Comparison of rider type by month

WITH MonthlyMetrics AS(
	SELECT
		ride_month AS [Month],
		SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS [Casual Trips],
		SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS [Member Trips],
		COUNT(*) AS [Total Trips]
	FROM all_trips_master
	GROUP BY ride_month
),
SummaryRows AS(
	SELECT
		[Month], [Casual Trips], [Member Trips], [Total Trips]
	FROM MonthlyMetrics

	UNION ALL
	
		SELECT
		'13',
		SUM([Casual Trips]),
		SUM([Member Trips]),
		SUM([Total Trips])
	FROM MonthlyMetrics
)
SELECT
	[Month],
	[Casual Trips],
	ROUND([Casual Trips] * 100.0 / [Total Trips], 2) AS [Casual Proportion (%)],
	[Member Trips],
	ROUND([Member Trips] * 100.0 / [Total Trips], 2) AS [Member Proportion (%)],
	[Total Trips]
FROM SummaryRows
ORDER BY [Month];