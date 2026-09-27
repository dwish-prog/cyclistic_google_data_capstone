-- add duration, day, and month columns

ALTER TABLE all_trips_master
ADD
	ride_length_minutes AS DATEDIFF(minute, started_at, ended_at),
	day_of_week AS DATENAME(weekday, started_at),
	ride_month AS MONTH(started_at);

SELECT TOP 10 * FROM all_trips_master;