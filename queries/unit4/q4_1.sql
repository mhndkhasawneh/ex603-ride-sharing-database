-- 4.1.1 Calculate the count, total, average, minimum, and maximum of your theme’s metric across the whole event table, and how many distinct actors appear.

SELECT
    COUNT(*) AS total_trips,
    SUM(fare_amount) AS total_fare,
    AVG(fare_amount) AS average_fare,
    MIN(fare_amount) AS minimum_fare,
    MAX(fare_amount) AS maximum_fare,
    COUNT(DISTINCT rider_id) AS unique_riders
FROM trips;

-- 4.1.2 calculate the event (trip) count and average metric for each producer (driver). Sort the results from the producer with the most events to the producer with the fewest.

SELECT
    driver_id,
    COUNT(*) AS total_trips,
    AVG(fare_amount) AS average_fare
FROM trips
GROUP BY driver_id
ORDER BY total_trips DESC;

-- 4.1.3 Which producers have enough volume for their rate to mean anything? A producer with only a few events may have a high failure rate that is not representative of their usual performance. Choose a minimum event-count threshold and use HAVING to include only producers who meet that threshold. Explain why you selected your threshold.

SELECT
    driver_id,
    COUNT(*) AS total_trips,
    AVG(fare_amount) AS average_fare
FROM trips
GROUP BY driver_id
HAVING COUNT(*) >= 10
ORDER BY total_trips DESC;

-- 4.1.4 How does the picture change along two dimensions at once? Leadership also wants to understand how performance varies across regions. Write a query that groups the data by two dimensions, including region, and calculates the relevant summary statistics. Your results should contain one row for each combination of the two dimensions so that regional leaders can review their results.

SELECT
    driver_id,
    pickup_city,
    COUNT(*) AS total_trips,
    AVG(fare_amount) AS average_fare
FROM trips
GROUP BY driver_id, pickup_city
ORDER BY driver_id, pickup_city;