-- combined individual month tables into a single master table

SELECT * INTO all_trips_master
FROM (
	SELECT * FROM dbo.[202507-divvy-tripdata]
	UNION ALL
	SELECT * FROM dbo.[202508-divvy-tripdata]
	UNION ALL
	SELECT * FROM dbo.[202509-divvy-tripdata]
	UNION ALL
	SELECT * FROM dbo.[202510-divvy-tripdata]
	UNION ALL
	SELECT * FROM dbo.[202511-divvy-tripdata]
	UNION ALL
	SELECT * FROM dbo.[202512-divvy-tripdata]
	UNION ALL
	SELECT * FROM dbo.[202601-divvy-tripdata]
	UNION ALL
	SELECT * FROM dbo.[202602-divvy-tripdata]
	UNION ALL
	SELECT * FROM dbo.[202603-divvy-tripdata]
	UNION ALL
	SELECT * FROM dbo.[202604-divvy-tripdata]
	UNION ALL
	SELECT * FROM dbo.[202605-divvy-tripdata]
	UNION ALL
	SELECT * FROM dbo.[202606-divvy-tripdata]
) AS combined_data;