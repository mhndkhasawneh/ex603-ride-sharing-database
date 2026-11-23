
-- Task 6.1, Question 1A
-- How does each trip's fare compare with its driver's average fare?

SELECT
    t.trip_id,
    t.driver_id,
    t.fare_amount,
    ROUND(
        AVG(t.fare_amount) OVER (
            PARTITION BY t.driver_id
        ), 2
    ) AS driver_avg_fare,
    ROUND(
        t.fare_amount -
        AVG(t.fare_amount) OVER (
            PARTITION BY t.driver_id
        ), 2
    ) AS difference_from_avg
FROM trips AS t
ORDER BY t.driver_id, t.trip_id;



-- Task 6.1, Question 1B
-- What is each driver's average fare when trips are grouped?

SELECT
    driver_id,
    ROUND(AVG(fare_amount), 2) AS driver_avg_fare
FROM trips
GROUP BY driver_id
ORDER BY driver_id;




-- Task 6.1, Question 2
-- How do ROW_NUMBER, RANK, and DENSE_RANK
-- rank drivers by their total number of trips?

WITH driver_trip_counts AS (
    SELECT
        d.driver_id,
        d.driver_name,
        COUNT(t.trip_id) AS total_trips
    FROM drivers AS d
    LEFT JOIN trips AS t
        ON d.driver_id = t.driver_id
    GROUP BY d.driver_id, d.driver_name
)
SELECT
    driver_id,
    driver_name,
    total_trips,
    ROW_NUMBER() OVER (
        ORDER BY total_trips DESC, driver_id
    ) AS row_number,
    RANK() OVER (
        ORDER BY total_trips DESC
    ) AS rank,
    DENSE_RANK() OVER (
        ORDER BY total_trips DESC
    ) AS dense_rank
FROM driver_trip_counts
ORDER BY total_trips DESC, driver_id;




-- Task 6.1, Question 3
-- How are drivers divided into four activity bands,
-- and can tied drivers fall into different bands?

WITH driver_trip_counts AS (
    SELECT
        d.driver_id,
        d.driver_name,
        COUNT(t.trip_id) AS total_trips
    FROM drivers AS d
    LEFT JOIN trips AS t
        ON d.driver_id = t.driver_id
    GROUP BY d.driver_id, d.driver_name
)
SELECT
    driver_id,
    driver_name,
    total_trips,
    NTILE(4) OVER (
        ORDER BY total_trips DESC, driver_id
    ) AS activity_band
FROM driver_trip_counts
ORDER BY activity_band, total_trips DESC, driver_id;
