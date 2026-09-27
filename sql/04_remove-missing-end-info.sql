-- removed corrupted trip end records

DELETE FROM all_trips_master
WHERE end_lat IS NULL
OR end_lng IS NULL;