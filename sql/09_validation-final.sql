-- final validation

-- 1. Verify row count matches expectations after deletions
SELECT COUNT(*) AS total_remaining_rows FROM all_trips_master;

-- 2. Verify all chronological anomalies are gone (Should return 0)
SELECT COUNT(*) AS remaining_invalid_durations 
FROM all_trips_master 
WHERE ended_at <= started_at;

-- 3. Verify critical nulls are eliminated (Should return 0)
SELECT COUNT(*) AS remaining_coordinate_nulls 
FROM all_trips_master 
WHERE end_lat IS NULL OR end_lng IS NULL;

-- 4. Verify known test data is eliminated (Should return 0)
SELECT COUNT(*) AS remaining_test_stations 
FROM all_trips_master 
WHERE start_station_name = 'Hastings Test Station';

-- 5. Sanity check categorical integrity (Should only return 'member' and 'casual')
SELECT member_casual, COUNT(*) AS user_count
FROM all_trips_master
GROUP BY member_casual;