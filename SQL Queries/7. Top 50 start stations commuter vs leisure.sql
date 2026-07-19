-- Top 50 Weekday Start Stations for Members (Commuter Hubs) with Coordinates
WITH TopMemberStations AS (
    SELECT TOP 500
        start_station_name AS [Station Name],
        COUNT(*) AS [Trip Count]
    FROM all_trips_master
    WHERE member_casual = 'member'
      AND day_of_week NOT IN ('Saturday', 'Sunday')
      AND start_station_name IS NOT NULL
    GROUP BY start_station_name
    ORDER BY COUNT(*) DESC
),
Coordinates AS (
    SELECT
        start_station_name,
        ROUND(AVG(start_lat), 4) AS [start_lat],
        ROUND(AVG(start_lng), 4) AS [start_lng]
    FROM all_trips_master
    WHERE start_station_name IS NOT NULL
    GROUP BY start_station_name
)
SELECT
    'Member Weekday' AS [Profile],
    t.[Station Name],
    t.[Trip Count],
    c.[start_lat],
    c.[start_lng]
FROM TopMemberStations t
INNER JOIN Coordinates c
    ON t.[Station Name] = c.start_station_name;

-- Top 50 Weekend Start Stations for Casual Riders (Leisure Hubs) with Coordinates
WITH TopCasualStations AS (
    SELECT TOP 500
        start_station_name AS [Station Name],
        COUNT(*) AS [Trip Count]
    FROM all_trips_master
    WHERE member_casual = 'casual'
      AND day_of_week IN ('Saturday', 'Sunday')
      AND start_station_name IS NOT NULL
    GROUP BY start_station_name
    ORDER BY COUNT(*) DESC
),
Coordinates AS (
    SELECT
        start_station_name,
        ROUND(AVG(start_lat), 4) AS [start_lat],
        ROUND(AVG(start_lng), 4) AS [start_lng]
    FROM all_trips_master
    WHERE start_station_name IS NOT NULL
    GROUP BY start_station_name
)
SELECT 
    'Casual Weekend' AS [Profile],
    t.[Station Name],
    t.[Trip Count],
    c.[start_lat],
    c.[start_lng]
FROM TopCasualStations t
INNER JOIN Coordinates c 
    ON t.[Station Name] = c.start_station_name;