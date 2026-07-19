SELECT
    ISNULL(member_casual, 'Total') AS [Rider type],
    COUNT(*) AS [Total trips],
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM all_trips_master), 2) AS [Proportion of trips]
FROM all_trips_master
GROUP BY ROLLUP(member_casual);