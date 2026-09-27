-- removed invalid records

DELETE FROM all_trips_master
WHERE ended_at <= started_at
   OR start_station_name = 'Hastings Test Station';