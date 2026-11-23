
-- Task 6.3, Part A
-- What are the three highest-fare trips for each driver?
-- Ties are broken by trip_id so each driver gets at most
-- three trips, even when multiple trips have equal fares.

WITH ranked_trips AS (
    SELECT
        t.driver_id,
        t.trip_id,
        t.requested_at,
        t.fare_amount,

        ROW_NUMBER() OVER (
            PARTITION BY t.driver_id
            ORDER BY t.fare_amount DESC, t.trip_id
        ) AS fare_rank,

        FIRST_VALUE(t.fare_amount) OVER (
            PARTITION BY t.driver_id
            ORDER BY t.fare_amount DESC, t.trip_id
        ) AS highest_fare

    FROM trips AS t
)
SELECT
    driver_id,
    trip_id,
    requested_at,
    fare_amount,
    fare_rank,
    highest_fare
FROM ranked_trips
WHERE fare_rank <= 3
ORDER BY driver_id, fare_rank;







-- Task 6.3, Part B
-- How does the rider no-show rate change from month to month,
-- and are any months missing from the dataset?

WITH monthly AS (
    SELECT
        DATE_TRUNC('month', requested_at)::date AS month,
        COUNT(*) AS total_trips,
        COUNT(*) FILTER (
            WHERE cancellation_reason = 'Rider no show'
        ) AS rider_no_shows,
        100.0 * COUNT(*) FILTER (
            WHERE cancellation_reason = 'Rider no show'
        ) / NULLIF(COUNT(*), 0) AS no_show_rate
    FROM trips
    GROUP BY DATE_TRUNC('month', requested_at)::date
),
monthly_comparison AS (
    SELECT
        *,
        LAG(month) OVER (
            ORDER BY month
        ) AS previous_month,
        LAG(no_show_rate) OVER (
            ORDER BY month
        ) AS previous_no_show_rate
    FROM monthly
)
SELECT
    month,
    total_trips,
    rider_no_shows,
    ROUND(no_show_rate, 2) AS no_show_rate_pct,
    ROUND(previous_no_show_rate, 2) AS previous_rate_pct,

    CASE
        WHEN previous_month = (month - INTERVAL '1 month')::date
        THEN ROUND(no_show_rate - previous_no_show_rate, 2)
    END AS change_percentage_points,

    CASE
        WHEN previous_month = (month - INTERVAL '1 month')::date
        THEN ROUND(
            100.0 * (no_show_rate - previous_no_show_rate)
            / NULLIF(previous_no_show_rate, 0), 2
        )
    END AS month_over_month_pct_change,

    CASE
        WHEN previous_month IS NULL THEN 'First month'
        WHEN previous_month <> (month - INTERVAL '1 month')::date
            THEN 'Missing month(s)'
        ELSE 'Consecutive'
    END AS month_check

FROM monthly_comparison
ORDER BY month;



-- Task 6.4 (supporting query for the closing memo)
-- Which kinds of trips were not marked completed, and how much of the
-- total does each make up? Cancelled trips never finished; disputed trips
-- have a completion time and a recorded fare, but their status is disputed.

SELECT
    trip_status,
    COALESCE(cancellation_reason, '(none)') AS cancellation_reason,
    COUNT(*) AS trips,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_all_trips,
    COUNT(completed_at) AS trips_with_completion_time,
    SUM(fare_amount) AS recorded_fares
FROM trips
GROUP BY trip_status, cancellation_reason
ORDER BY trip_status, trips DESC, cancellation_reason;



-- Task 6.4 (supporting query for the closing memo)
-- Did the failure problem change from quarter to quarter, measured both
-- as rider no-shows and as all trips not marked completed
-- (cancelled or disputed)?

WITH quarterly AS (
    SELECT
        DATE_TRUNC('quarter', requested_at)::date AS quarter_start,
        COUNT(*) AS total_trips,
        COUNT(*) FILTER (
            WHERE cancellation_reason = 'Rider no show'
        ) AS rider_no_shows,
        COUNT(*) FILTER (
            WHERE trip_status = 'cancelled'
        ) AS cancelled_trips,
        COUNT(*) FILTER (
            WHERE trip_status = 'disputed'
        ) AS disputed_trips,
        COUNT(*) FILTER (
            WHERE trip_status <> 'completed'
        ) AS not_completed_trips
    FROM trips
    GROUP BY DATE_TRUNC('quarter', requested_at)::date
)
SELECT
    quarter_start,
    total_trips,
    rider_no_shows,
    ROUND(100.0 * rider_no_shows / NULLIF(total_trips, 0), 2) AS no_show_rate_pct,
    cancelled_trips,
    disputed_trips,
    not_completed_trips,
    ROUND(100.0 * not_completed_trips / NULLIF(total_trips, 0), 2) AS not_completed_rate_pct,
    not_completed_trips
        - LAG(not_completed_trips) OVER (ORDER BY quarter_start) AS change_vs_prev_quarter
FROM quarterly
ORDER BY quarter_start;







