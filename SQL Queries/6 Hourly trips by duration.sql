WITH TimeData AS (
    SELECT 
        -- Extract hour and handle day names deterministically
        DATEPART(HOUR, started_at) AS [Hour],
        day_of_week AS [Day],
        CASE WHEN day_of_week IN ('Saturday', 'Sunday') THEN 'Weekend' ELSE 'Weekday' END AS [DayType],
        member_casual,
        -- Calculate trip duration in minutes
        DATEDIFF(SECOND, started_at, ended_at) / 60.0 AS DurationMinutes
    FROM all_trips_master
),
HourlyAggregates AS (
    SELECT 
        [Day],
        [Hour],
        -- Volume breakdown
        SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS [Casual Trips],
        SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS [Member Trips],
        -- Behavioral duration breakdown
        ROUND(AVG(CASE WHEN member_casual = 'casual' THEN DurationMinutes END), 2) AS [Casual Avg Duration],
        ROUND(AVG(CASE WHEN member_casual = 'member' THEN DurationMinutes END), 2) AS [Member Avg Duration],
        -- Explicit sort indexing
        CASE [Day]
            WHEN 'Monday'    THEN 1 WHEN 'Tuesday'  THEN 2 WHEN 'Wednesday' THEN 3 
            WHEN 'Thursday'  THEN 4 WHEN 'Friday'   THEN 5 WHEN 'Saturday'  THEN 6 
            WHEN 'Sunday'    THEN 7 
        END AS [DaySort]
    FROM TimeData
    GROUP BY [Day], [Hour]
)
SELECT 
    [Day],
    [Hour],
    [Casual Trips],
    [Member Trips],
    [Casual Avg Duration],
    [Member Avg Duration]
FROM HourlyAggregates
ORDER BY [DaySort], [Hour];