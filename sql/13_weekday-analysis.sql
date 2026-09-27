-- Compare Days of week

WITH DailyMetrics AS(
	SELECT
		day_of_week AS [Day],
		SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS [Casual Trips],
		SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS [Member Trips],
		COUNT(*) AS [Total Trips],
		CASE RTRIM(LTRIM(day_of_week))
            WHEN 'Monday'    THEN 1
            WHEN 'Tuesday'   THEN 2
            WHEN 'Wednesday' THEN 3
            WHEN 'Thursday'  THEN 4
            WHEN 'Friday'    THEN 5
            WHEN 'Saturday'  THEN 6
            WHEN 'Sunday'    THEN 7
			ELSE 11 -- Handles any unexpected values safely
        END AS [SortOrder]
	FROM all_trips_master
	GROUP BY day_of_week
)
SELECT
	[Day],
	[Casual Trips],
	ROUND([Casual Trips] * 100.0 / SUM([Casual Trips]) OVER(), 2) AS [Casual Proportion (%)],
	[Member Trips],
	ROUND([Member Trips] * 100.0 / SUM([Member Trips]) OVER(), 2) AS [Member Proportion (%)],
	[Total Trips],
	ROUND([Total Trips] * 100.0 / SUM([Total Trips]) OVER(), 2) AS [Overall Dataset Average (%)]
FROM DailyMetrics
ORDER BY [SortOrder];

-- Comparison of rider type by day

WITH DailyMetrics AS(
	SELECT
		day_of_week AS [Day],
		SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS [Casual Trips],
		SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS [Member Trips],
		COUNT(*) AS [Total Trips],
		CASE RTRIM(LTRIM(day_of_week))
            WHEN 'Monday'    THEN 1
            WHEN 'Tuesday'   THEN 2
            WHEN 'Wednesday' THEN 3
            WHEN 'Thursday'  THEN 4
            WHEN 'Friday'    THEN 5
            WHEN 'Saturday'  THEN 6
            WHEN 'Sunday'    THEN 7
            ELSE 11 -- Handles any unexpected values safely
        END AS [SortOrder]
	FROM all_trips_master
	GROUP BY day_of_week
),
SummaryRows AS(
	SELECT
		[Day], [Casual Trips], [Member Trips], [Total Trips], [SortOrder]
	FROM DailyMetrics

	UNION ALL
	
	SELECT
		'Weekday Total (Mon-Fri)',
		SUM([Casual Trips]),
		SUM([Member Trips]),
		SUM([Total Trips]),
		8 AS [SortOrder]
	FROM DailyMetrics
	WHERE [Day] NOT IN('Saturday', 'Sunday')

	UNION ALL

	SELECT
		'Weekend Total (Mon-Fri)',
		SUM([Casual Trips]),
		SUM([Member Trips]),
		SUM([Total Trips]),
		9 AS [SortOrder]
	FROM DailyMetrics
	WHERE [Day] IN('Saturday', 'Sunday')

	UNION ALL

		SELECT
		'Grand Total',
		SUM([Casual Trips]),
		SUM([Member Trips]),
		SUM([Total Trips]),
		10 AS [SortOrder]
	FROM DailyMetrics
)
SELECT
	[Day],
	[Casual Trips],
	ROUND([Casual Trips] * 100.0 / [Total Trips], 2) AS [Casual Proportion (%)],
	[Member Trips],
	ROUND([Member Trips] * 100.0 / [Total Trips], 2) AS [Member Proportion (%)],
	[Total Trips]
FROM SummaryRows
ORDER BY [SortOrder];