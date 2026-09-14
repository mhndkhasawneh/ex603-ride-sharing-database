# Schema Definition

This document defines the five relations used in the Ride Sharing database, including their attributes, domains, and primary keys.

## 1. Riders

**Relation:** `riders`

| Attribute | Domain | Description |
|---|---|---|
| `rider_id` | Positive integer | Unique identifier for each rider |
| `display_name` | Non-empty text | Name displayed for the rider on the platform |

**Primary Key:** `rider_id`

**Relation schema:**

`riders(rider_id, display_name)`

---

## 2. Drivers

**Relation:** `drivers`

| Attribute | Domain | Description |
|---|---|---|
| `driver_id` | Positive integer | Unique identifier for each driver |
| `display_name` | Non-empty text | Name displayed for the driver on the platform |
| `is_active` | Boolean | Indicates whether the driver is currently active on the platform |
| `rating` | Decimal number from 1.0 to 5.0 | Driver's current rating |

**Primary Key:** `driver_id`

**Relation schema:**

`drivers(driver_id, display_name, is_active, rating)`

---

## 3. Trips

**Relation:** `trips`

| Attribute | Domain | Description |
|---|---|---|
| `trip_id` | Positive integer | Unique identifier for each trip |
| `rider_id` | Positive integer | Identifies the rider who took the trip |
| `driver_id` | Positive integer | Identifies the driver who provided the trip |
| `pickup_location` | Non-empty text | Location where the trip begins |
| `dropoff_location` | Non-empty text | Destination where the trip ends |
| `started_at` | Date and time | Date and time when the trip started |
| `fare_amount` | Non-negative decimal monetary amount | Fare charged for the trip |

**Primary Key:** `trip_id`

**Relation schema:**

`trips(trip_id, rider_id, driver_id, pickup_location, dropoff_location, started_at, fare_amount)`

---

## 4. Driver Badges

**Relation:** `driver_badges`

| Attribute | Domain | Description |
|---|---|---|
| `badge_id` | Positive integer | Unique identifier for each badge |
| `badge_name` | Non-empty text | Name of the badge |

**Primary Key:** `badge_id`

**Relation schema:**

`driver_badges(badge_id, badge_name)`

---

## 5. Driver Badge Awards

**Relation:** `driver_badge_awards`

| Attribute | Domain | Description |
|---|---|---|
| `driver_id` | Positive integer | Identifies the driver receiving the badge |
| `badge_id` | Positive integer | Identifies the badge awarded to the driver |
| `awarded_at` | Date and time | Date and time when the badge was awarded |

**Primary Key:** (`driver_id`, `badge_id`)

**Relation schema:**

`driver_badge_awards(driver_id, badge_id, awarded_at)`

The composite primary key ensures that the same badge cannot be awarded to the same driver more than once.