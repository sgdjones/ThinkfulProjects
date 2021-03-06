-- 1) What are the three longest trips on rainy days?

WITH raining as 
(
SELECT 
DATE(date) rain_date
From weather
WHERE events ~* 'Rain'
GROUP BY 1
) 
SELECT
	t.trip_id,
	t.duration,
	DATE(t.start_date) 
FROM trips as t
JOIN raining as r
on DATE(t.start_date) = r.rain_date
ORDER BY duration DESC
LIMIT 3;


-- 2) Which station is full most often?

SELECT
	status.station_id, 
	stations.name,
	COUNT(CASE WHEN docks_available=0 then 'empty' END) empty_count
FROM status
JOIN stations
on status.station_id = stations.station_id
GROUP BY 1,2
ORDER BY empty_count DESC;


-- 3) Return a list of stations with a count of number of trips 
-- 		starting at that station but ordered by dock count.

SELECT trips.start_station as station_name, 
	COUNT(trips.start_station) station_count, 
	stations.dockcount 
FROM trips
JOIN stations
ON trips.start_station = stations.name
GROUP BY 1,3
ORDER BY stations.dockcount;


-- 4) (Challenge) What's the length of the longest 
-- 		trip for each day it rains anywhere?

WITH rainy as 
(
SELECT 
	DATE(date) rain_date
From weather
WHERE events ~* 'Rain'
GROUP BY 1
),
rain_trips as (
SELECT
	trip_id,
	duration,
	DATE(trips.start_date) rain_trips_date
FROM trips
JOIN rainy
on rainy.rain_date = DATE(trips.start_date)
ORDER BY duration DESC
)
SELECT 
	rain_trips_date,
	max(duration) max_duration
from rain_trips
GROUP BY 1
ORDER BY max_duration DESC;
