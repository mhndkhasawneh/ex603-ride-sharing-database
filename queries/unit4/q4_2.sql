-- Part A: Two numbers in one pass
-- For each producer, compute the total number of events and the total number of events classified as failures, in a single pass over the event table, without a WHERE clause filtering the whole query. The outliers here are the producers you will name in your finding.

-- ✓  CASE used inside an aggregate — for example SUM(CASE WHEN ... THEN 1 ELSE 0 END) or COUNT(CASE WHEN ... END).

-- ✓  Both totals appearing as separate columns in one result set.

SELECT
    driver_id,
    COUNT(*) AS total_trips,
    SUM(
        CASE
            WHEN cancellation_reason = 'Rider no show' THEN 1
            ELSE 0
        END
    ) AS rider_no_shows
FROM trips
GROUP BY driver_id
ORDER BY rider_no_shows DESC;

-- Part B: Subtotals and a grand total
-- The regional director wants subtotals per region and a platform grand total, not the detail rows. Write a query that produces regional subtotals and a platform-wide grand total without including the individual detail rows.

-- ✓  GROUP BY ROLLUP (...), or GROUPING SETS or CUBE.

-- ✓  A written note identifying which rows are the subtotals and which is the grand total.

SELECT
    CASE
        WHEN GROUPING(pickup_city) = 1 THEN 'All Regions'
        ELSE pickup_city
    END AS region,
    COUNT(*) AS total_trips,
    SUM(
        CASE
            WHEN cancellation_reason = 'Rider no show' THEN 1
            ELSE 0
        END
    ) AS rider_no_shows
FROM trips
GROUP BY ROLLUP(pickup_city)
ORDER BY GROUPING(pickup_city), pickup_city;

-- Part C: A two-step pipeline
-- Leadership wants to establish a baseline for evaluating high-volume producers. That needs two steps: use a WITH clause to create an intermediate result that summarizes performance for each producer, then use a second aggregation or filter on that intermediate result to calculate a baseline for high-volume producers.

-- ✓  A WITH clause producing an intermediate aggregate.

-- ✓  A second aggregation or filter applied to that intermediate result.

WITH driver_performance AS (
    SELECT
        driver_id,
        COUNT(*) AS total_trips,
        SUM(
            CASE
                WHEN cancellation_reason = 'Rider no show' THEN 1
                ELSE 0
            END
        ) AS rider_no_shows
    FROM trips
    GROUP BY driver_id
)
SELECT
    COUNT(*) AS high_volume_drivers,
    SUM(total_trips) AS total_trips,
    SUM(rider_no_shows) AS total_no_shows,
    ROUND(100.0 * SUM(rider_no_shows) / SUM(total_trips),2) AS failure_rate_percent
FROM driver_performance
WHERE total_trips >= 10;

