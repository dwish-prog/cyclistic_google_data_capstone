-- searched for invalid trip durations

SELECT COUNT(*) AS negative_or_zero_duration_trips
FROM all_trips_master
WHERE ended_at <= started_at;

-- searched for test station names

SELECT start_station_name, COUNT(*) AS trip_count
FROM all_trips_master
WHERE start_station_name LIKE '%test%'
   OR start_station_name LIKE '%checking%'
GROUP BY start_station_name;