-- general stats. This takes ages!

SELECT
 	member_casual AS [Rider type],
 	COUNT(member_casual) AS [Total trips],
 	ROUND(COUNT(member_casual) * 100.0 / SUM(COUNT(member_casual)) OVER(), 2) AS [Proportion of trips]
FROM all_trips_master
GROUP BY member_casual;

SELECT
 	rideable_type AS [Bike type],
 	COUNT(rideable_type) AS [Total trips],
 	ROUND(COUNT(rideable_type) * 100.0 / SUM(COUNT(rideable_type)) OVER(), 2) AS [Proportion of trips]
FROM all_trips_master
GROUP BY rideable_type;

SELECT
 	day_of_week AS [Day],
 	COUNT(day_of_week) AS [Total trips],
 	ROUND(COUNT(day_of_week) * 100.0 / SUM(COUNT(day_of_week)) OVER(), 2) AS [Proportion of trips]
FROM all_trips_master
GROUP BY day_of_week;

SELECT
 	ride_month AS [Month],
 	COUNT(day_of_week) AS [Total trips],
 	ROUND(COUNT(day_of_week) * 100.0 / SUM(COUNT(day_of_week)) OVER(), 2) AS [Proportion of trips]
FROM all_trips_master
GROUP BY day_of_week;

WITH CombinedStationEvents AS (
    SELECT
        ISNULL(start_station_name, 'No Station Listed') AS station_name,
        ISNULL(start_station_id, 'N/A') AS station_id
    FROM all_trips_master

    UNION ALL

   SELECT
        ISNULL(end_station_name, 'No Station Listed') AS station_name,
        ISNULL(end_station_id, 'N/A') AS station_id
    FROM all_trips_master
)
SELECT
    station_name AS [Station Name],
    station_id AS [Station ID],
    COUNT(*) AS [Total Activity Volume],
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS [Percentage of Total Activity (%)]
FROM CombinedStationEvents
GROUP BY
    station_name,
    station_id
ORDER BY
    [Total Activity Volume] DESC;
