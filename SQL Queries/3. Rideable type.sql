WITH RideMetrics AS(
	SELECT
		rideable_type AS [Bike Type],
		SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS [Casual Trips],
		SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS [Member Trips],
		COUNT(*) AS [Total Trips]
	FROM all_trips_master
	GROUP BY rideable_type
)
SELECT
	[Bike Type],
	[Casual Trips],
	ROUND([Casual Trips] * 100.0 / SUM([Casual Trips]) OVER(), 2) AS [Casual Proportion (%)],
	[Member Trips],
	ROUND([Member Trips] * 100.0 / SUM([Member Trips]) OVER(), 2) AS [Member Proportion (%)],
	[Total Trips],
	ROUND([Total Trips] * 100.0 / SUM([Total Trips]) OVER(), 2) AS [Overall Dataset Average (%)]
FROM RideMetrics;