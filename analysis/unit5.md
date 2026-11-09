<!-- 5.1 -->
<!-- What feature or report on your platform could use the three-table join from Question 1? What information would it display? -->
<!-- Why is the junction table important for answering Question 2? What would make this analysis more difficult without it? -->

### Task 5.1
I joined the trips, riders, and drivers tables to show which rider and driver were associated with each trip and when the trip was requested and completed. This could be useful for a trip history report or for customer support when investigating ride issues.

I also joined drivers with driver_badges through driver_badge_awards to identify drivers who earned the Safe Driving badge. The query returned 9 drivers, including Driver 2 but not Driver 3. The junction table was necessary because a driver can earn multiple badges, and the same badge can be awarded to multiple drivers. Without it, tracking these relationships would be more difficult.

Finally, I used a self join to compare drivers who share the same home city. Driver 3 had a rating of 4.91 and was inactive, while Drivers 6 and 11 were active with lower ratings. This showed how a self join can help compare drivers and identify differences in their characteristics.




<!-- 5.2 -->
<!-- Which producers were excluded by the inner join? Report their identifiers.
What does it mean when a producer has no events? What are some possible explanations?
How could a report based only on an inner join give leadership an incomplete picture of the platform?
Why might leadership want to identify producers who have never been active?
What action could leadership take based on these findings?
Distinguish between what your data shows and what would require further investigation. For example, a producer with no events may be inactive, but the data alone may not explain why. -->


### Task 5.2

The LEFT JOIN returned all 15 drivers, while the INNER JOIN returned only 13. Driver IDs 14 and 15 were excluded because they had no recorded trips.

The RIGHT JOIN produced the same results as the LEFT JOIN when I reversed the table order. The FULL OUTER JOIN also returned all 15 drivers, with no additional unmatched trip records appearing in the results.

I then used NOT EXISTS and EXCEPT to identify drivers without trips. Both queries returned Drivers 14 and 15, confirming that the results were consistent.

A driver with no trips might be newly onboarded, inactive, or having difficulty receiving ride requests. However, the data only shows that these drivers have no recorded trips. It does not explain why.

This matters because a report based only on an INNER JOIN could give leadership an incomplete picture of the platform by excluding drivers with no activity. Leadership could investigate Drivers 14 and 15 to determine whether they need onboarding support, have availability issues, or face other problems preventing them from completing trips.




<!-- 5.3
Give an example of when a Cartesian product could be useful on your platform, or explain why you would not need one.
Which join algorithms did PostgreSQL choose for your query?
What information in the execution plan helps explain those choices?
Why is it useful to understand the selected join algorithms?
What changes to the data or database might make another join algorithm more appropriate?
Support your explanation with observations from your execution plan. -->
### Task 5.3

The CROSS JOIN combined 3 drivers with 3 badges and returned 9 rows. It generated every possible combination, even when a driver had not actually earned a badge. A CROSS JOIN could be useful for creating a list of all possible driver and badge combinations to identify which badges each driver has or has not earned. However, the actual badge awards would still need to be checked against the driver_badge_awards table.

For the three-table join, PostgreSQL used a Hash Join to match trips with riders, followed by a Nested Loop to match the results with drivers. It also used Memoize to reuse driver records, resulting in 187 cache hits and only 13 index searches.

The execution plan showed that PostgreSQL scanned 200 trips and 30 riders, used the primary key index to find matching drivers, and sorted the final results by request time. The query returned 200 rows with an execution time of 0.501 ms.

Understanding the execution plan helps explain how PostgreSQL processes a query and where performance improvements might be possible. These join algorithms worked efficiently for this small dataset. With larger tables, different indexes, or changes in the number of matching records, PostgreSQL might choose another algorithm based on its estimated cost.







<!-- Reflection (150–250 words)
In Task 5.3, you examined the execution plan for your three-table join. Reflect on the following question: What changes to your data or database schema might cause PostgreSQL to choose a different join algorithm?

Consider factors such as table size, indexes, and the number of matching records. Explain how these changes could influence query performance. Include your reflection in /analysis/unit5.md. -->
### Reflection

In this assignment, I learned that PostgreSQL can use different join algorithms within the same query. When I ran EXPLAIN ANALYZE on my three-table join, PostgreSQL used a Hash Join to connect trips with riders and a Nested Loop to connect the results with drivers.

The Hash Join worked well because the riders table was small, containing only 30 records. PostgreSQL could build a hash table and use it to find matching riders for the 200 trips. For the drivers, PostgreSQL used an index scan with Memoize, which allowed it to reuse previously retrieved driver records. This resulted in 187 cache hits and only 13 index searches.

I think PostgreSQL might choose different algorithms if the database grows. For example, if the trips table contained millions of records, repeatedly looking up drivers might become more expensive, and a Hash Join could become a better option. Adding indexes could also make Nested Loops more efficient. If both inputs were already sorted by their join keys, a Merge Join might become more attractive.

I also learned that PostgreSQL considers estimated costs, table sizes, and available indexes when selecting a plan. The best join algorithm depends on the data and how it is organized, not just the SQL query itself.