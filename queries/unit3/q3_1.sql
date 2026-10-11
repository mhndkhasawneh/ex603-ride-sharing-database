
-- 3.1.1 Find active, highly rated drivers. Sort and return the first ten.
SELECT driver_id, driver_name, avg_rating
FROM  drivers
WHERE is_active = TRUE
AND avg_rating >= 4.5
ORDER BY avg_rating DESC
LIMIT 10;

-- 3.1.2 - All possible event statuses. Display the distinct values in the trip status column.
SELECT DISTINCT trip_status
FROM  trips;


-- 3.1.3 Filter the trips in two different ways. First way: one query that filters a numeric range
SELECT *
FROM  trips
WHERE distance_km < 10;

-- 3.1.3 Filter the trips in two different ways. Second way: one query that filters using an explicit list of values with IN.
SELECT *
FROM  trips
WHERE pickup_city IN ('Hue', 'Hanoi');


-- 3.1.4 find producers (drivers) whose names match a text pattern using LIKE, and identify records where a reason/value is missing (NULL). Use COALESCE to replace a missing value with a useful label
SELECT
    d.driver_id,
    d.driver_name,
    t.trip_id,
    completed_at,
    coalesce(t.cancellation_reason, 'Not Cancelled') AS cancellation_reason
FROM drivers d
join trips t
    ON d.driver_id=t.driver_id
WHERE d.driver_name LIKE 'Driver_1%'
AND t.cancellation_reason IS NULL;







-- 3.1.5 Make the results easier to understand. Create a query with calculated/computed columns that would make sense to someone who does not work with SQL.
--   Use CASE where appropriate to create plain-language categories.
SELECT  trip_id,requested_at,
    CASE EXTRACT(MONTH FROM requested_at)
        WHEN 1 THEN 'Jan'
        WHEN 2 THEN 'Feb'
        WHEN 3 THEN 'Mar'
        WHEN 4 THEN 'Apr'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'Jun'
        WHEN 7 THEN 'Jul'
        WHEN 8 THEN 'Aug'
        WHEN 9 THEN 'Sep'
        WHEN 10 THEN 'Oct'
        WHEN 11 THEN 'Nov'
        WHEN 12 THEN 'Dec'
        ELSE 'Unknown'
    END AS requested_month
FROM trips;
