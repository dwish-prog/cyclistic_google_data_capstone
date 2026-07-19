WITH BaseData AS (
    SELECT 
        -- Standardize day format dynamically and flag weekends
        day_of_week AS [RawDay],
        CASE WHEN day_of_week IN ('Saturday', 'Sunday') THEN 'Weekend' ELSE 'Weekday' END AS [DayType],
        CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END AS IsCasual,
        CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END AS IsMember
    FROM all_trips_master
),
AggregatedData AS (
    SELECT 
        -- Grouping sets will evaluate individual days, group by day types, and then clear filters for grand total
        CASE 
            WHEN GROUPING(RawDay) = 0 THEN RawDay
            WHEN GROUPING(DayType) = 0 THEN DayType + ' Total'
            ELSE 'Grand Total'
        END AS [Day],
        SUM(IsCasual) AS [Casual Trips],
        SUM(IsMember) AS [Member Trips],
        COUNT(*) AS [Total Trips],
        -- Deterministic sorting logic matching the aggregation levels
        CASE 
            WHEN GROUPING(RawDay) = 0 THEN
                CASE RawDay
                    WHEN 'Monday'    THEN 1 WHEN 'Tuesday'  THEN 2 WHEN 'Wednesday' THEN 3 
                    WHEN 'Thursday'  THEN 4 WHEN 'Friday'   THEN 5 WHEN 'Saturday'  THEN 6 
                    WHEN 'Sunday'    THEN 7 
                END
            WHEN GROUPING(DayType) = 0 THEN
                CASE WHEN DayType = 'Weekday' THEN 8 ELSE 9 END
            ELSE 10
        END AS [SortOrder]
    FROM BaseData
    GROUP BY GROUPING SETS (
        (RawDay),
        (DayType),
        ()
    )
)
SELECT
    [Day],
    [Casual Trips],
    -- % of trips that day belonging to casuals (Leisure intensity profile)
    ROUND([Casual Trips] * 100.0 / [Total Trips], 2) AS [Casual Within-Day (%)],
    -- % of all casual trips over the whole dataset (Volume distribution profile)
    ROUND([Casual Trips] * 100.0 / SUM(CASE WHEN [Day] = 'Grand Total' THEN [Casual Trips] ELSE 0 END) OVER(), 2) AS [Casual Share of Dataset (%)],
    
    [Member Trips],
    -- % of trips that day belonging to members (Commute intensity profile)
    ROUND([Member Trips] * 100.0 / [Total Trips], 2) AS [Member Within-Day (%)],
    -- % of all member trips over the whole dataset (Volume distribution profile)
    ROUND([Member Trips] * 100.0 / SUM(CASE WHEN [Day] = 'Grand Total' THEN [Member Trips] ELSE 0 END) OVER(), 2) AS [Member Share of Dataset (%)],
    
    [Total Trips],
    ROUND([Total Trips] * 100.0 / SUM(CASE WHEN [Day] = 'Grand Total' THEN [Total Trips] ELSE 0 END) OVER(), 2) AS [Total Share of Dataset (%)]
FROM AggregatedData
ORDER BY [SortOrder];