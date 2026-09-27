WITH TimedTrips AS (
    SELECT 
        member_casual,
        -- Extract the hour (0-23) from your start timestamp column
        -- Replace 'started_at' with your actual timestamp column name if different
        DATEPART(HOUR, started_at) AS [HourOfDay],
        CASE 
            WHEN day_of_week IN ('Saturday', 'Sunday') THEN 'Weekend'
            ELSE 'Weekday'
        END AS [DayType]
    FROM all_trips_master
)
SELECT 
    [DayType],
    [HourOfDay],
    SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS [Casual Trips],
    SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS [Member Trips],
    COUNT(*) AS [Total Trips]
FROM TimedTrips
GROUP BY 
    [DayType],
    [HourOfDay]
ORDER BY 
    [DayType],
    [HourOfDay];