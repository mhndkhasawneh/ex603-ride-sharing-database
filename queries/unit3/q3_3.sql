-- Task 3.3: Hand the team a corrected query
-- Which riders were involved in rider no-show trips?
SELECT distinct rider_id
FROM trips
WHERE cancellation_reason = 'Rider no show';

-- Task 3.3: Hand the team a corrected query
-- Which riders were involved in rider no-show trips?
-- First as a subquery using IN or NOT IN.
SELECT rider_id, rider_name
FROM riders
WHERE rider_id IN (
    SELECT rider_id
    FROM trips
    WHERE cancellation_reason = 'Rider no show'
)
ORDER BY rider_id;


-- Task 3.3: Hand the team a corrected query
-- Which riders were involved in rider no-show trips?
-- common table expression
WITH no_show_riders AS (
    SELECT rider_id
    FROM trips
    WHERE cancellation_reason = 'Rider no show'
)
SELECT rider_id, rider_name
FROM riders
WHERE rider_id IN (
    SELECT rider_id
    FROM no_show_riders
)
ORDER BY rider_id;


-- Task 3.3: Hand the team a corrected query
-- Which riders were involved in rider no-show trips?
-- third way Join
SELECT DISTINCT r.rider_id, r.rider_name
FROM riders r
JOIN trips t
    ON r.rider_id = t.rider_id
WHERE t.cancellation_reason = 'Rider no show'
ORDER BY r.rider_id;



-- Task 3.3: Hand the team a corrected query
-- Which riders were involved in rider no-show trips?
-- A fourth way would be to do it with EXISTS
SELECT rider_id, rider_name
FROM riders r
WHERE EXISTS (
    SELECT 1
    FROM trips t
    WHERE t.rider_id = r.rider_id
      AND t.cancellation_reason = 'Rider no show'
)
ORDER BY r.rider_id;



-- 4 will demonstrate with screenshots

-- 3.3.5 Duplicate rider IDs in matching trips would make the JOIN return duplicate riders if DISTINCT were not used.