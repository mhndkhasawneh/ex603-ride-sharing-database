-- PART A Compare INNER JOIN and LEFT JOIN

-- 1- Use LEFT JOIN to return all producers, including those who have never had an event.
-- 2- Write an equivalent query using INNER JOIN.
-- 3- Compare the results and determine how many producers are excluded by the inner join.
-- 4- Explain which producers are missing and why.
-- 5- Your results must include a count of the producers excluded by the inner join.

-- Hint: When counting producers, use their unique identifiers so that producers with multiple events are not counted more than once.

-- How many trips does each driver have, including drivers with no trips?

SELECT
    d.driver_id,
    d.driver_name,
    COUNT(t.trip_id) AS total_trips
FROM drivers AS d
LEFT JOIN trips AS t
    ON d.driver_id = t.driver_id
GROUP BY d.driver_id, d.driver_name
ORDER BY d.driver_id;


-- How many trips does each driver have when only drivers with trips are included?

SELECT
    d.driver_id,
    d.driver_name,
    COUNT(t.trip_id) AS total_trips
FROM drivers AS d
INNER JOIN trips AS t
    ON d.driver_id = t.driver_id
GROUP BY d.driver_id, d.driver_name
ORDER BY d.driver_id;

-- How many drivers are excluded by the INNER JOIN?

SELECT
    COUNT(*) AS excluded_drivers
FROM drivers AS d
WHERE NOT EXISTS (
    SELECT 1
    FROM trips AS t
    WHERE t.driver_id = d.driver_id
);



-- Part B: Explore RIGHT JOIN and FULL OUTER JOIN
-- Next, examine the same relationship using two additional join types.

-- Write a RIGHT JOIN that returns the same records as your LEFT JOIN from Part A.
-- Compare the results to confirm that they match.
-- Write a FULL OUTER JOIN that includes matching and unmatched records from both tables.
-- Explain what a full outer join can reveal that a left join or right join alone may not show.
-- Be sure to verify your results rather than assuming the queries are equivalent.


-- Can a RIGHT JOIN return the same drivers and trip counts as the LEFT JOIN?

SELECT
    d.driver_id,
    d.driver_name,
    COUNT(t.trip_id) AS total_trips
FROM trips AS t
RIGHT JOIN drivers AS d
    ON t.driver_id = d.driver_id
GROUP BY d.driver_id, d.driver_name
ORDER BY d.driver_id;




-- Which drivers and trips are included when unmatched records from both tables are preserved?

SELECT
    d.driver_id,
    d.driver_name,
    COUNT(t.trip_id) AS total_trips
FROM drivers AS d
FULL OUTER JOIN trips AS t
    ON d.driver_id = t.driver_id
GROUP BY d.driver_id, d.driver_name
ORDER BY d.driver_id;





-- Part C: Find Producers with No Events Using Two Approaches
-- Write two queries that identify producers who have never had an event and compare them.

-- ✓  NOT EXISTS.

-- ✓  EXCEPT.

-- Run both queries and compare their results.

-- In one or two sentences, explain how the approaches differ and confirm whether they identify the same producers.



-- Which drivers have no recorded trips using NOT EXISTS?

SELECT
    d.driver_id,
    d.driver_name
FROM drivers AS d
WHERE NOT EXISTS (
    SELECT 1
    FROM trips AS t
    WHERE t.driver_id = d.driver_id
)
ORDER BY d.driver_id;




-- Which drivers have no recorded trips using EXCEPT?

SELECT
    d.driver_id,
    d.driver_name
FROM drivers AS d

EXCEPT

SELECT
    d.driver_id,
    d.driver_name
FROM drivers AS d
INNER JOIN trips AS t
    ON d.driver_id = t.driver_id

ORDER BY driver_id;







