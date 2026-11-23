# Unit 6 — Closing Memo

## Is the Failure Problem Getting Better or Worse?

**Short answer: the data does not show a reliable improvement or a reliable decline.** Both measures below were lowest in Q4, which is encouraging, but the quarter-to-quarter differences amount to only a few trips. That is too few to separate a real change from normal variation.

### Two ways to measure "failure"

Since Unit 3, we have tracked **rider no-shows**: trips cancelled with the reason "Rider no show." Leadership's question is about the platform as a whole, so I also measured **all trips not marked completed**. In this dataset these are trips with one of two statuses:

- **Cancelled (34 trips):** the trip never finished. None has a completion time, and every one is recorded with a $0.00 fare. Reasons: rider no-show 12, rider cancelled 8, payment failed 7, driver unavailable 7.
- **Disputed (10 trips):** the ride did take place. All 10 have a completion time and a recorded fare, totalling $209.44, but they are marked as disputed. The data does not say what was disputed or how it was resolved.

Of 200 trips in 2023, 156 (78%) were completed and 44 (22%) were not. Rider no-shows are 12 of those 44.

*Source: Task 6.4 status and reason breakdown, [q6_3.sql](../queries/unit6/q6_3.sql).*

### Quarterly results

| Quarter | Trips | Rider no-shows | No-show rate | Cancelled | Disputed | Not completed | Not-completed rate |
|---|---:|---:|---:|---:|---:|---:|---:|
| Q1 | 53 | 4 | 7.55% | 12 | 1 | 13 | 24.53% |
| Q2 | 48 | 3 | 6.25% | 7 | 3 | 10 | 20.83% |
| Q3 | 51 | 3 | 5.88% | 8 | 5 | 13 | 25.49% |
| Q4 | 48 | 2 | 4.17% | 7 | 1 | 8 | 16.67% |

*Source: Task 6.4 quarterly comparison, [q6_3.sql](../queries/unit6/q6_3.sql).*

- **Rider no-shows** fell every quarter, from 7.55% to 4.17%. In trips, that is a change from 4 to 2. With about 50 trips per quarter, one trip moves the rate by about 2 percentage points.
- **Trips not completed** did not move in one direction: 24.53%, 20.83%, then 25.49% in Q3 (the highest), then 16.67% in Q4 (the lowest). Q4 had 5 fewer such trips than Q3.
- **Monthly rates are noisier still.** Each month has only 11 to 21 trips, so one no-show moves the monthly rate by about 5 to 9 points. October and November had no rider no-shows, and December had 2 of 16 trips (12.50%). *Source: Task 6.3 Part B, [q6_3.sql](../queries/unit6/q6_3.sql).*

The no-show rate went in the right direction, but a two-trip difference, combined with a broader measure that rose in Q3 before falling in Q4, does not support saying the platform has improved. It also does not support saying it got worse.

## What Should the Team Do Next Quarter?

1. **Report all trips not marked completed, broken down by status and reason, with rider no-shows as one line.** No-shows are only 12 of the 44 trips that did not complete normally. Reporting no-shows alone leaves out most of the problem.
2. **Review results quarterly, and always show counts next to rates.** Monthly rates swing by 5 to 9 points per trip at current volume. A change of one or two trips should be treated as something to keep watching, not as a result.
3. **Review the 7 payment-failed cancellations and the 10 disputed trips.** These are the largest categories outside rider behaviour, and the disputed trips carry $209.44 of recorded fares. The data does not show their causes, so the first step is to look at these trips individually and find out what happened.
4. **Start recording why trips fail.** Useful additions are who cancelled and when, whether a pickup reminder was sent, and when drivers were online. Our data shows what happened, but not why. Until it does, we should not attribute no-shows or cancellations to individual drivers or riders.

## Supporting SQL

- [q6_3.sql — Task 6.4 queries](../queries/unit6/q6_3.sql): status and reason breakdown; quarterly comparison of rider no-shows and trips not completed.
- [q6_3.sql — Task 6.3 Part B](../queries/unit6/q6_3.sql): monthly rider no-show rates, month-over-month changes, and the missing-month check.

## Limitation

With 200 trips in one year, the dataset is too small to confirm a trend. A second year of data, or a higher trip volume, would show whether Q4's lower rates continue.
