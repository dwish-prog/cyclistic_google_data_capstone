-- checked lat/long variance for start_station nulls

SELECT start_lat, start_lng, start_station_name, start_station_id
FROM all_trips_master
WHERE start_station_name IS NULL
ORDER BY start_lat, start_lng;