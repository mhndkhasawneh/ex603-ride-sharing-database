
# Unit 4: From Rows to Insight

## Task 4.1

The operations manager would use the per-driver breakdown to see how drivers are performing. However, averages don't show how much individual fares vary, and trip counts don't tell us which trips were completed, cancelled, or involved a rider no-show. I would want to look at the individual fares, trip statuses, and cancellation reasons to better understand what's behind those numbers before making any decisions.

### Minimum Trip Threshold

I chose 10 trips because most drivers had between 11 and 21 trips, while one had only 6. I wanted to exclude drivers with very few trips because even one trip could significantly affect their average or failure rate. This makes the comparison more meaningful, although 10 trips is still a small sample.

## Task 4.2

### Part A

The query answers two questions: How many trips did each driver have, and how many were rider no-shows? Looking at both helps us avoid judging drivers by the number of no-shows alone.

### Part B

The regional director would use the subtotals to compare cities without going through individual trips. The grand total shows the overall situation and helps leadership decide whether the issue needs attention across the platform or only in certain regions.

### Part C

The pipeline answers what the overall rider no-show rate is for drivers with at least 10 trips. It first calculates each driver's numbers, then uses those results to calculate the combined rate for high-volume drivers.

## Reflection

Conditional aggregation lets us calculate multiple things in one query instead of running separate queries for each result. In this assignment, I used it to count the total trips and rider no-shows for each driver. The CASE statement helped me count only the no-shows without removing the other trips from the results.

I could have done the same thing with two separate queries, one counting all trips and another counting the no-shows. Both would work, but the database might need to read and process the same data twice. With only 200 trips, this probably wouldn't make much difference. However, with a million rows, repeating that work could take more time and resources, especially if the queries were being used regularly in a dashboard.

I also find conditional aggregation easier to work with because I get everything together instead of having to combine results from different queries. It also reduces the chance of accidentally comparing numbers that were calculated using different filters or different sets of records.

Of course, one query doesn't always mean the database will physically scan the table only once. That depends on how the database executes it. But I think conditional aggregation is a better approach here because it's simpler and avoids unnecessary repeated work.