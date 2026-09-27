USE CyclisticCapstone;

WITH AggregatedStats AS (
    SELECT 
        ISNULL(member_casual, 'Total Dataset') AS [Rider Type],
        AVG(ride_length_minutes) AS [Average Duration],
        MIN(ride_length_minutes) AS [Min Duration],
        MAX(ride_length_minutes) AS [Max Duration]
    FROM all_trips_master
    GROUP BY GROUPING SETS ((member_casual), ())
),
CasualMedian AS (
    SELECT DISTINCT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ride_length_minutes) OVER() AS val 
    FROM all_trips_master WHERE member_casual = 'casual'
),
MemberMedian AS (
    SELECT DISTINCT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ride_length_minutes) OVER() AS val 
    FROM all_trips_master WHERE member_casual = 'member'
),
TotalMedian AS (
    SELECT DISTINCT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ride_length_minutes) OVER() AS val 
    FROM all_trips_master
)
SELECT 
    a.[Rider Type],
    ROUND(a.[Average Duration], 2) AS [Average Duration (Min)],
    ROUND(CASE 
        WHEN a.[Rider Type] = 'casual' THEN (SELECT val FROM CasualMedian)
        WHEN a.[Rider Type] = 'member' THEN (SELECT val FROM MemberMedian)
        ELSE (SELECT val FROM TotalMedian)
    END, 2) AS [Median Duration (Min)],
    a.[Min Duration] AS [Min Duration (Min)],
    a.[Max Duration] AS [Max Duration (Min)]
FROM AggregatedStats AS a;