-- Task 3.2: Find the bug - Part A: The rows that vanished





-- Task 3.2: Find the bug - Part A: The rows that vanished
-- Write a query with a negation or inequality predicate on that column — for example WHERE status != 'completed' — and record the row count it returns.
-- 3.2.A.2 Count of no shows
SELECT count(*) AS rider_no_show
FROM trips
WHERE cancellation_reason != 'Rider no show';


-- Task 3.2: Find the bug - Part A: The rows that vanished
-- Write a second query counting the rows the first one silently omitted, and show that the two counts do not sum to the table total.
-- Count Nulls
SELECT  COUNT(*) AS Omitted_count
FROM trips
WHERE cancellation_reason is NULL;


-- Task 3.2: Find the bug - Part A: The rows that vanished
-- Repair the first query using an explicit IS NULL condition or COALESCE, so it returns what you intended.
-- Counting the nulls with the no shows
SELECT COUNT(*) cancellation_reason
FROM trips
WHERE  cancellation_reason != 'Rider no show'
OR cancellation_reason is null;

-- Everything count
SELECT COUNT(*) AS total_count
FROM trips;


-- Task 3.2 Part A: the two row counts and the table total together, so a reader can see they do not sum. Then the repaired query returning the full count.
WITH counts AS (
    SELECT
        (SELECT COUNT(*)
         FROM trips
         WHERE cancellation_reason != 'Rider no show') AS not_rider_no_show,

        (SELECT COUNT(*)
         FROM trips
         WHERE cancellation_reason IS NULL) AS null_count,

        (SELECT COUNT(*)
         FROM trips
         WHERE cancellation_reason != 'Rider no show'
            OR cancellation_reason IS NULL) AS repaired_count,

        (SELECT COUNT(*)
         FROM trips) AS total_count
)
SELECT
    not_rider_no_show,
    null_count,
    repaired_count,
    total_count
FROM counts;








-- Task 3.2:  Part B: The alias that did not exist yet
-- Write a query defining an alias in SELECT and referencing that alias in WHERE. Capture the error message verbatim.
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
FROM trips
WHERE requested_month = 'Jun';

-- Task 3.2:  Part B: The alias that did not exist yet
-- Produce two correct rewrites: one repeating the expression in WHERE
-- Repeat the expression in WHERE instead of using the SELECT alias.
SELECT trip_id, requested_at,
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
FROM trips
WHERE CASE EXTRACT(MONTH FROM requested_at)
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
    END = 'Jan';





-- Task 3.2:  Part B: The alias that did not exist yet
-- Produce two correct rewrites: one wrapping the query in a CTE or subquery so the alias becomes a real column.
WITH trip_months AS (
    SELECT trip_id, requested_at,
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
    FROM trips
)
SELECT trip_id, requested_at, requested_month
FROM trip_months
WHERE requested_month = 'Jan';





-- Task 3.2:  Part B: The alias that did not exist yet
-- Produce two correct rewrites: one wrapping the query in a CTE or subquery so the alias becomes a real column.
-- subquery
SELECT trip_id, requested_at, requested_month
FROM (
    SELECT trip_id, requested_at,
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
    FROM trips
) AS trip_months
WHERE requested_month = 'Jan';












