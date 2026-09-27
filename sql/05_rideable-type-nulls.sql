-- counted rows with null start station names grouped by rideable_type

SELECT rideable_type, COUNT(*) AS null_count
FROM all_trips_master
WHERE start_station_name IS NULL
GROUP BY rideable_type;