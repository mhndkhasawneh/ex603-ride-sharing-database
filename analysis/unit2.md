# Unit 2 Analysis

## Assignment Instructions

> The [`schema.sql`](../schema.sql) script encodes decisions it cannot explain. Write the explanation in `/analysis/unit2.md`.
>
> ### The Constraints Table
>
> One row per foreign key. Three columns: the foreign key, the `ON DELETE` choice, and the reason in one sentence. Then, below the table, expand on the choices in prose:
>
> For each `ON DELETE` choice, describe the real event it governs. What actually happens on your platform when a producer is removed? Name who or what is affected by the choice you made, and what would go wrong under the alternative.
>
> ### The `CHECK` Constraints
>
> For each `CHECK` constraint, describe the invalid state it makes unstorable and how that state could otherwise arise.
>
> ### Changes to the Unit 1 Design
>
> If implementation forced a change to your Unit 1 design, update the ERD rather than leaving the two out of step, and say what changed in `/analysis/unit2.md`. Discovering that a diagram was incomplete is a normal part of building, not a failure.

---

## Constraints Table

| Foreign Key | `ON DELETE` Choice | Reason |
|---|---|---|
| `riders.referred_by → riders.rider_id` | `SET NULL` | A rider can be removed without deleting another rider who was referred by them, because the referral is no longer needed once the referring rider is gone. |
| `trips.rider_id → riders.rider_id` | `RESTRICT` | A rider cannot be deleted while trips still reference that rider because the trip history should remain associated with a valid rider. |
| `trips.driver_id → drivers.driver_id` | `RESTRICT` | A driver cannot be deleted while trips still reference that driver because deleting the driver would leave historical trips without the driver who performed them. |
| `driver_badge_awards.driver_id → drivers.driver_id` | `CASCADE` | When a driver is deleted, that driver's badge awards should also be deleted because those awards have no meaning without the driver. |
| `driver_badge_awards.badge_id → driver_badges.badge_id` | `CASCADE` | When a badge is deleted, its award records should also be deleted because those records represent awards of a badge that no longer exists. |

## `ON DELETE` Choices

### Rider Referrals — `SET NULL`

The `referred_by` foreign key represents one rider referring another rider to the platform. If the referring rider is removed, the referred rider should remain on the platform. The `ON DELETE SET NULL` choice removes only the reference to the deleted rider by setting `referred_by` to `NULL`.

Using `CASCADE` here would be inappropriate because deleting one rider could also delete another rider simply because that person was referred by them. Using `RESTRICT` would prevent the referring rider from being deleted as long as another rider still referenced them, even though the referral relationship is not necessary for the referred rider to continue using the platform.

### Trip Rider — `RESTRICT`

The `rider_id` foreign key in `trips` identifies the rider who took a particular trip. A trip is part of the platform's historical record, so a rider who already has trips cannot simply be deleted while those trips still reference them.

Using `RESTRICT` prevents the deletion and protects the relationship between the trip and the rider. If `CASCADE` were used instead, deleting a rider could also delete all of that rider's trip records. This would cause historical trip information to disappear simply because a rider was removed.

### Trip Driver — `RESTRICT`

The `driver_id` foreign key in `trips` identifies the driver who performed a trip. If a driver has completed trips, those trips should continue to identify the driver associated with them.

Using `RESTRICT` prevents a driver from being deleted while trip records still depend on that driver. If `CASCADE` were used, deleting a driver could also delete the driver's historical trips, causing the platform to lose trip records.

### Driver Badge Awards — Driver `CASCADE`

The `driver_id` foreign key in `driver_badge_awards` represents a badge that was awarded to a particular driver. The award record depends on that driver existing.

If a driver is deleted, `CASCADE` automatically removes the driver's rows from `driver_badge_awards`. Keeping those rows would not make sense because they would describe badges belonging to a driver who no longer exists. Using `RESTRICT` instead would prevent a driver from being deleted until every badge award associated with the driver was manually removed.

### Driver Badge Awards — Badge `CASCADE`

The `badge_id` foreign key in `driver_badge_awards` identifies which badge was awarded to a driver. If a badge itself is removed from the system, the records showing that badge being awarded should also be removed.

Using `CASCADE` keeps the junction table consistent by automatically deleting those award records. Using `RESTRICT` would require all existing awards of the badge to be manually removed before the badge itself could be deleted.

## `CHECK` Constraints

### Rider Cannot Refer Themself

```sql
CHECK (referred_by IS DISTINCT FROM rider_id)
```

This constraint prevents a rider from being recorded as their own referrer. Without the constraint, an incorrect insert or update could set a rider's `referred_by` value equal to their own `rider_id`, creating a self-referral that does not represent a valid referral relationship on the platform.

### Driver Rating Range

```sql
CHECK (rating BETWEEN 1.00 AND 5.00)
```

This constraint prevents a driver's rating from being stored outside the valid range of `1.00` through `5.00`. Without it, an incorrect insert or update could store values such as `0`, `6`, or another rating outside the platform's rating scale.

### Non-Negative Trip Fare

```sql
CHECK (fare_amount >= 0)
```

This constraint prevents a trip from having a negative fare. Without the constraint, an incorrect value such as `-10.00` could be inserted or produced by an update, even though a negative amount does not represent a valid trip fare.

## Changes to the Unit 1 Design

During implementation, the rider referral relationship was added to the design. The `riders` table now contains a nullable `referred_by` foreign key that references `riders.rider_id`. This creates a recursive relationship in which one rider can refer another rider.

The Unit 1 ERD was updated to include this relationship so that the diagram and the implemented database schema remain consistent.