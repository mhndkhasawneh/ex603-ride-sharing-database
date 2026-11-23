
-- Task 6.2, Part A
-- How does each driver's trip fare compare with
-- the previous and next trip in chronological order?

WITH trip_comparison AS (
    SELECT
        trip_id,
        driver_id,
        requested_at,
        fare_amount,
        LAG(fare_amount) OVER (
            PARTITION BY driver_id
            ORDER BY requested_at, trip_id
        ) AS previous_fare,
        LEAD(fare_amount) OVER (
            PARTITION BY driver_id
            ORDER BY requested_at, trip_id
        ) AS next_fare
    FROM trips
)
SELECT
    trip_id,
    driver_id,
    requested_at,
    fare_amount,
    previous_fare,
    next_fare,
    fare_amount - previous_fare AS fare_delta
FROM trip_comparison
WHERE driver_id = 6
ORDER BY requested_at, trip_id;



-- Task 6.2, Part A (supporting check)
-- What else was recorded about Driver 6's trips, so that large fare
-- changes can be checked against trip status, distance, and surge?

SELECT
    trip_id,
    requested_at,
    trip_status,
    cancellation_reason,
    distance_km,
    surge_multiplier,
    fare_amount
FROM trips
WHERE driver_id = 6
ORDER BY requested_at, trip_id;



-- Task 6.2, Part B
-- How do total recorded fares and recent average fares
-- change over the platform's trip history?

SELECT
    trip_id,
    requested_at,
    fare_amount,

    SUM(fare_amount) OVER (
        ORDER BY requested_at, trip_id
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS running_total,

    ROUND(
        AVG(fare_amount) OVER (
            ORDER BY requested_at, trip_id
            ROWS BETWEEN 6 PRECEDING
            AND CURRENT ROW
        ), 2
    ) AS moving_avg_7_trips,

    ROUND(
        100.0 * SUM(fare_amount) OVER (
            ORDER BY requested_at, trip_id
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) / 3000, 2
    ) AS target_pct

FROM trips
ORDER BY requested_at, trip_id;



-- Task 6.2, Part C
-- Did Driver 6 have any gaps longer than 30 days
-- between consecutive recorded trips?

WITH driver_trip_history AS (
    SELECT
        trip_id,
        driver_id,
        requested_at,
        LAG(requested_at) OVER (
            PARTITION BY driver_id
            ORDER BY requested_at, trip_id
        ) AS previous_trip_at
    FROM trips
)
SELECT
    driver_id,
    trip_id,
    previous_trip_at,
    requested_at AS next_trip_at,
    ROUND(
        (
            EXTRACT(EPOCH FROM (requested_at - previous_trip_at))
            / 86400
        )::numeric, 1
    ) AS gap_days
FROM driver_trip_history
WHERE driver_id = 6
  AND requested_at - previous_trip_at > INTERVAL '30 days'
ORDER BY gap_days DESC;



-- Task 6.2, Part C (supporting check)
-- How long does each driver usually go between recorded trips,
-- and how does Driver 6's longest gap compare with other drivers?

WITH driver_trip_history AS (
    SELECT
        driver_id,
        requested_at - LAG(requested_at) OVER (
            PARTITION BY driver_id
            ORDER BY requested_at, trip_id
        ) AS gap
    FROM trips
)
SELECT
    driver_id,
    COUNT(*) AS recorded_trips,
    ROUND(
        (EXTRACT(EPOCH FROM AVG(gap)) / 86400)::numeric, 1
    ) AS avg_days_between_trips,
    ROUND(
        (EXTRACT(EPOCH FROM MAX(gap)) / 86400)::numeric, 1
    ) AS longest_gap_days
FROM driver_trip_history
GROUP BY driver_id
ORDER BY longest_gap_days DESC, driver_id;
