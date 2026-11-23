# Unit 6 — Window Functions and Analytics

## Task 6.1 — Compute Across a Window Without Collapsing

### Question 1: Window Functions vs. GROUP BY

**Business question:** How does each trip's fare compare with the average fare for its driver?

The window function returned 200 rows, keeping every trip alongside its driver's average fare. This allows us to identify trips with unusually high or low fares compared with that driver's typical trip.

The GROUP BY query returned 13 rows, one for each driver with recorded trips. Although it shows each driver's average fare, it loses the individual trip details. As a result, we cannot identify unusual trips from the grouped output alone.

One caution: cancelled trips are recorded with a fare of $0.00 (the Task 6.4 breakdown in `q6_3.sql` shows recorded fares of $0.00 for every cancellation reason). These $0.00 trips are included in each driver's average, so the average understates a typical completed fare, and every cancelled trip appears "unusually low." For a fare-outlier check, an average of completed trips only would be a fairer baseline.

### Question 2: Driver Leaderboard

A driver activity leaderboard could use DENSE_RANK() to rank drivers by their number of recorded trips. In our dataset, Drivers 5 and 7 each have 18 recorded trips, so both receive rank 4.

ROW_NUMBER() would assign them different positions despite their equal trip counts. RANK() would recognize the tie but skip the next rank. DENSE_RANK() is more appropriate for a leaderboard that recognizes equal activity and displays consecutive ranking levels.

Trip volume measures activity, not necessarily driver quality, so this leaderboard should not be treated as a measure of safety or service quality.

### Question 3: NTILE(4) — Driver Activity Bands

I used NTILE(4) to divide the 15 drivers into four groups based on their number of recorded trips. One interesting result was that Drivers 5 and 7 both had 18 trips, but Driver 5 was placed in Band 1 while Driver 7 was placed in Band 2.

This happens because NTILE divides rows into roughly equal-sized groups without keeping tied values together. For a real driver rewards program, this could be unfair because two drivers with the same trip count might receive different rewards. I would avoid using NTILE alone to determine rewards when drivers have equal activity.

## Task 6.2 — Compare Each Row to Its Neighbors

### Part A: Comparing Consecutive Trips

I used LAG() and LEAD() to compare each driver's trip fare with the previous and next trip in chronological order. For Driver 6, the query returned 21 trips.

The largest change occurred at Trip 71, where the fare dropped from $50.25 on the previous trip (Trip 78) to $6.17, a difference of −$44.08.

To check this, I looked up the trips' other recorded details (Part A supporting check in `q6_2.sql`). Both trips were completed. Trip 78 covered 24.96 km with a 1.50 surge multiplier, while Trip 71 covered 3.98 km with a 1.25 multiplier. The shorter distance and lower surge are consistent with the lower fare, but distance does not fully determine fare on its own: Trip 83 (24.83 km, no surge) cost $28.94, while Trip 67 (16.29 km, 2.00 surge) cost $42.02. The data does not include the pricing formula, so I cannot say exactly how much of the change each factor explains.

Some large deltas mean something different. Four of Driver 6's trips were cancelled and recorded at $0.00 (Trips 75, 65, 74 and 66), so 8 of the 20 deltas involve a cancelled trip: four drops to $0.00 and four recoveries afterward. A large delta therefore tells someone to look closer, not that something went wrong. They should first check `trip_status`: if the trip was cancelled, review the cancellation reason (for example, Payment failed on Trip 66); if it was completed, compare distance and surge before treating it as a pricing problem.

### Part B: Running Totals and Moving Averages

I used a window function to calculate the running total of recorded trip fares over time. I set an illustrative target of $3,000. The running total first exceeded this target on October 15, 2023, reaching $3,044.08. By the end of the dataset, the total reached $3,628.19, or 120.94% of the target.

A regular SUM() would only show the final total, while a running total shows how the amount accumulated over time and when the target was reached.

I also used a seven-trip moving average to smooth out changes between individual fares. Because ROWS counts trips rather than days, the window does not cover seven days: the dataset has 200 trips spread over roughly 362 days, so seven trips cover about two weeks on average. I chose seven trips because about two weeks is long enough that one trip does not dominate the average, but short enough to still show recent dips. For example, the average fell to $9.73 on December 16, when two $0.00 trips were inside the window. A smaller window would swing with almost every cancelled trip, while a larger window (for example, 30 trips, about two months) would smooth out short dips like this one.

ROWS counts individual records, while RANGE can include multiple rows that share the same ORDER BY value when the frame ends at CURRENT ROW. For example, if two trips have the same timestamp and we order only by that timestamp, a RANGE-based running total would include both together, while ROWS would process them separately. I used ROWS with a trip ID tiebreaker for a consistent running total. In this dataset no two trips share a timestamp, so RANGE would give the same result here; the tiebreaker protects the query if ties appear in future data.

### Part C: Gap Detection

I used LAG() to compare consecutive trip timestamps for each driver and identify gaps longer than 30 days.

For Driver 6, the query found three gaps: 39.8 days, 39.4 days, and 30.4 days. The longest gap occurred between March 18 and April 27, 2023.

To judge whether these gaps are unusual, I compared every driver's spacing between trips (Part C supporting check in `q6_2.sql`). Driver 6 averages 16.9 days between recorded trips, so its longest gap is a little over twice its usual spacing. Driver 6's longest gap (39.8 days) is also the shortest "longest gap" of all 13 drivers with trips. Nine drivers have a gap longer than 60 days, and the longest is Driver 9's 112.6 days.

**My judgment: these gaps are best explained as a side effect of how events are recorded.** The `trips` table records only completed, cancelled or disputed trip requests. It does not record shifts, log-ins or when a driver was online. With only 6 to 21 recorded trips per driver per year, multi-week stretches without a trip are common across the whole platform, not unique to one driver. I also see no sign of a platform-wide recording outage: every month of 2023 contains trips (Task 6.3 Part B).

This is a judgment, not proof. The data cannot show that the driver stopped working, and it cannot rule out that some of the driver's trips were lost. Because the explanation is about recording, the right response is to collect driver availability or log-in history before treating any gap as a driver leaving, or as missing data.

## Task 6.3 — Build the Reporting Patterns

### Part A: Top Three Trips per Driver

I used ROW_NUMBER() and FIRST_VALUE() to identify the three highest-fare trips for each driver. The query returned 39 rows, representing three trips for each of the 13 drivers with recorded trips.

This could support a driver earnings analytics dashboard by highlighting the highest-value trips, although trip fares do not necessarily equal driver earnings.

I chose three trips because one trip might be unusual, while ten would provide too much information for a quick dashboard. Three gives drivers a useful comparison without overwhelming them.

I used ROW_NUMBER() to return exactly three trips per driver. If two trips have the same fare, the smaller trip_id comes first. This makes tie handling predictable and prevents extra rows when fares tie at third place. If the feature needed to treat tied trips equally, RANK() would keep every trip tied for third, at the cost of sometimes returning more than three.

The query does not filter by trip status, so disputed trips can appear in a driver's top three. Because a disputed fare may later change, a driver-facing version of this feature should add `WHERE trip_status = 'completed'` inside the CTE.

### Part B: Month-over-Month Comparison

I used DATE_TRUNC() to group trips by month and LAG() to compare each month's rider no-show rate with the previous month. The query included all 12 months of 2023, with no missing months.

The results show that rider no-show rates fluctuate considerably. March had the highest monthly rate at 18.18%, while October and November had no recorded rider no-shows. December increased to 12.50%, with 2 no-shows out of 16 trips.

A large month-over-month change could indicate a change in rider reliability, but at this volume it usually reflects one or two trips. Each month has only 11 to 21 trips, so a single no-show moves the monthly rate by about 5 to 9 percentage points. For example, February's −100% change was a drop from 2 no-shows to 0, and March's 18.18% peak was 2 no-shows out of 11 trips.

When a large change appears, someone should check the counts before the percentage. If the change is one or two trips, keep watching rather than act. If the rate stays high for two or more months, or the monthly count rises clearly above the usual one no-show per month, they should review the affected trips (pickup city, time of day and rider) before considering reminders or policy changes.

I used NULLIF() to avoid division by zero when the previous month's rate was zero. In those cases, the relative percentage change is undefined rather than zero.

## Final Reflection — Window Functions vs. GROUP BY

One useful reporting question for our rideshare platform is: How does each trip compare with the driver's average fare, and how does activity change over time?

With AVG() OVER (PARTITION BY driver_id), I was able to keep all 200 trips while displaying each driver's average fare next to every trip. This made it easy to compare individual trips with the driver's typical fare.

When I used GROUP BY instead, the query returned only 13 rows, one for each driver with recorded trips. The averages were still correct, but the individual trip information disappeared. To compare each trip with its driver average using GROUP BY, I would need an additional join or subquery.

Window functions also made it easier to compare trips over time. I used LAG() and LEAD() to examine consecutive fares, ROW_NUMBER() to identify the top three trips per driver, and SUM() with a window frame to calculate running totals.

The biggest lesson for me was that identifying a change does not automatically explain its cause. For example, a large fare decrease might simply mean the next trip was shorter. Window functions help identify patterns, but we still need business context before making decisions.