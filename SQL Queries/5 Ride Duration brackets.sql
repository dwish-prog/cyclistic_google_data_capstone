WITH BracketedTrips AS (
	SELECT
		member_casual,
		CASE
			WHEN ride_length_minutes <10 THEN '1. Under 10 mins'
			WHEN ride_length_minutes >= 10 AND ride_length_minutes < 30 THEN '2. 10-30 mins'
			WHEN ride_length_minutes >= 30 AND ride_length_minutes < 90 THEN '3. 30-90 mins'
			ELSE '4. Over 90 mins'
		END AS [Duration Bracket]
	FROM all_trips_master
)
SELECT
	[Duration Bracket],
	SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS [Casual Trips],
	SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS [Member Trips],
	COUNT(*) AS [Total Trips],
	ROUND(SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS [Casual Share (%)],
	ROUND(SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS [Member Share (%)]
FROM BracketedTrips
GROUP BY [Duration Bracket]
ORDER BY [Duration Bracket];