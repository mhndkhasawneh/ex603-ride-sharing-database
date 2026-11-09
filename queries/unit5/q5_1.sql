-- 5.1.1 Who are the people behind the events? Write a query that joins three tables to display the actor who performed each event, the producer associated with the event, and the event's date and time.
-- Which rider and driver are associated with each trip, and when was the trip requested and completed?

SELECT
    t.trip_id,
    r.rider_id,
    r.rider_name,
    d.driver_id,
    d.driver_name,
    t.requested_at,
    t.completed_at
FROM trips AS t
INNER JOIN riders AS r
    ON t.rider_id = r.rider_id
INNER JOIN drivers AS d
    ON t.driver_id = d.driver_id
ORDER BY t.requested_at;




-- 5.1.2 Do the producers identified in Assignment 4 share certain catalog credentials or tags? Write a query that connects the producer table to the catalog table through the junction table. Return the producers associated with your theme's catalog tag.
-- Which badges have Drivers 2 and 3 earned (drivers identified in assignment 4), and do they share any?

SELECT
    d.driver_id,
    d.driver_name,
    b.badge_id,
    b.badge_name,
    a.awarded_on
FROM drivers AS d
INNER JOIN driver_badge_awards AS a
    ON d.driver_id = a.driver_id
INNER JOIN driver_badges AS b
    ON a.badge_id = b.badge_id
WHERE d.driver_id IN (2, 3)
ORDER BY b.badge_name, d.driver_id;




-- 5.1.3 How do the producers compare with one another? Write a self join to compare records within the producer table. Use the results to explore whether the producers identified in Assignment 4 share characteristics with other producers or whether differences in activity levels may explain their performance.
-- Which other drivers share a home city with Drivers 2 and 3, and how do their ratings and activity statuses compare?

SELECT
    d1.driver_id AS driver_id,
    d1.driver_name AS driver_name,
    d1.home_city AS home_city,
    d1.avg_rating AS driver_rating,
    d1.is_active AS driver_active,
    d2.driver_id AS comparison_driver_id,
    d2.driver_name AS comparison_driver_name,
    d2.avg_rating AS comparison_rating,
    d2.is_active AS comparison_active
FROM drivers AS d1
INNER JOIN drivers AS d2
    ON d1.home_city = d2.home_city
    AND d1.driver_id <> d2.driver_id
WHERE d1.driver_id IN (2, 3)
ORDER BY d1.driver_id, d2.driver_id;
