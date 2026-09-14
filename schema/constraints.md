# Integrity Constraints

This document defines the integrity constraints for the Ride Sharing database. These constraints are intended to prevent invalid or inconsistent data from being stored.

## 1. Riders

### Primary Key
- `rider_id` is the primary key.
- Each rider must have a unique `rider_id`.
- `rider_id` cannot be null.

### Required Values
- `display_name` must not be null.
- `display_name` must not be empty.

---

## 2. Drivers

### Primary Key
- `driver_id` is the primary key.
- Each driver must have a unique `driver_id`.
- `driver_id` cannot be null.

### Required Values
- `display_name` must not be null or empty.
- `is_active` must not be null.
- `rating` must not be null.

### Value Constraints
- `rating` must be between `1.0` and `5.0`, inclusive.

---

## 3. Trips

### Primary Key
- `trip_id` is the primary key.
- Each trip must have a unique `trip_id`.
- `trip_id` cannot be null.

### Foreign Key: `rider_id`
- `rider_id` references `riders(rider_id)`.
- Every trip must reference an existing rider.
- `rider_id` cannot be null.
- **ON DELETE: RESTRICT**

**Justification:** Historical trip records should not disappear because a rider account is removed. A rider cannot be deleted while trips still reference that rider. This preserves the accuracy and auditability of trip history.

### Foreign Key: `driver_id`
- `driver_id` references `drivers(driver_id)`.
- Every trip must reference an existing driver.
- `driver_id` cannot be null.
- **ON DELETE: RESTRICT**

**Justification:** A driver's completed trips are historical business records. Preventing deletion of a driver who is referenced by existing trips protects historical fare and trip data.

### Required Values
- `pickup_location` must not be null or empty.
- `dropoff_location` must not be null or empty.
- `started_at` must not be null.
- `fare_amount` must not be null.

### Value Constraints
- `fare_amount` must be greater than or equal to `0`.

---

## 4. Driver Badges

### Primary Key
- `badge_id` is the primary key.
- Each badge must have a unique `badge_id`.
- `badge_id` cannot be null.

### Required Values
- `badge_name` must not be null or empty.

### Uniqueness
- `badge_name` must be unique.

**Justification:** Two different badge records should not represent the same named badge.

---

## 5. Driver Badge Awards

### Composite Primary Key
- The composite primary key is (`driver_id`, `badge_id`).
- The combination of `driver_id` and `badge_id` must be unique.
- This prevents the same badge from being awarded to the same driver more than once.

### Foreign Key: `driver_id`
- `driver_id` references `drivers(driver_id)`.
- Every badge award must reference an existing driver.
- `driver_id` cannot be null.
- **ON DELETE: CASCADE**

**Justification:** A badge award cannot exist without the driver it belongs to. If a driver is deleted and has no protected trip history preventing that deletion, the driver's badge-award records should also be removed automatically.

### Foreign Key: `badge_id`
- `badge_id` references `driver_badges(badge_id)`.
- Every badge award must reference an existing badge.
- `badge_id` cannot be null.
- **ON DELETE: CASCADE**

**Justification:** A badge award has no meaning if the badge definition no longer exists. If a badge is deleted, the related award records should also be deleted automatically.

### Required Values
- `awarded_at` must not be null.