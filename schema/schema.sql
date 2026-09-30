-- =================================================================
-- EX 603 Assignment 2 — schema.sql
-- Theme: Ride Sharing
-- Author: Mohannad Khasawneh
-- Target: PostgreSQL 14+
-- =================================================================


-- =================================================================
-- RESET
-- Drop tables in reverse creation order so that foreign-key
-- dependencies do not prevent a table from being dropped.
-- =================================================================

DROP TABLE IF EXISTS driver_badge_awards CASCADE;
DROP TABLE IF EXISTS trips CASCADE;
DROP TABLE IF EXISTS driver_badges CASCADE;
DROP TABLE IF EXISTS drivers CASCADE;
DROP TABLE IF EXISTS riders CASCADE;


-- -----------------------------------------------------------------
-- 1. riders
-- Created first because it does not depend on another table.
-- referred_by is a recursive foreign key: it references another
-- rider who referred this rider to join/use the platform.
-- -----------------------------------------------------------------

CREATE TABLE riders (
    rider_id     INTEGER GENERATED ALWAYS AS IDENTITY,
    display_name VARCHAR(100) NOT NULL,
    referred_by  INTEGER,

    CONSTRAINT pk_riders
        PRIMARY KEY (rider_id),

    CONSTRAINT fk_riders_referrer
        FOREIGN KEY (referred_by)
        REFERENCES riders (rider_id)
        ON DELETE SET NULL,

    CONSTRAINT chk_riders_no_self_referral
        CHECK (referred_by IS DISTINCT FROM rider_id)
);


-- -----------------------------------------------------------------
-- 2. drivers
-- Created before trips because trips references drivers.
-- rating is constrained to values from 1.00 through 5.00.
-- -----------------------------------------------------------------

CREATE TABLE drivers (
    driver_id    INTEGER GENERATED ALWAYS AS IDENTITY,
    display_name VARCHAR(100) NOT NULL,
    is_active    BOOLEAN NOT NULL,
    rating       NUMERIC(3,2) NOT NULL,

    CONSTRAINT pk_drivers
        PRIMARY KEY (driver_id),

    CONSTRAINT chk_drivers_rating
        CHECK (rating BETWEEN 1.00 AND 5.00)
);


-- -----------------------------------------------------------------
-- 3. driver_badges
-- Created before driver_badge_awards because the junction table
-- references this table.
-- Badge names are unique so the same badge is not defined twice.
-- -----------------------------------------------------------------

CREATE TABLE driver_badges (
    badge_id   INTEGER GENERATED ALWAYS AS IDENTITY,
    badge_name VARCHAR(100) NOT NULL,

    CONSTRAINT pk_driver_badges
        PRIMARY KEY (badge_id),

    CONSTRAINT uq_driver_badges_badge_name
        UNIQUE (badge_name)
);


-- -----------------------------------------------------------------
-- 4. trips
-- Created after riders and drivers because each trip references
-- exactly one rider and one driver.
-- RESTRICT preserves historical trip records by preventing a rider
-- or driver referenced by a trip from being deleted.
-- -----------------------------------------------------------------

CREATE TABLE trips (
    trip_id          INTEGER GENERATED ALWAYS AS IDENTITY,
    rider_id         INTEGER NOT NULL,
    driver_id        INTEGER NOT NULL,
    pickup_location  TEXT NOT NULL,
    dropoff_location TEXT NOT NULL,
    started_at       TIMESTAMP NOT NULL,
    fare_amount      NUMERIC(10,2) NOT NULL,

    CONSTRAINT pk_trips
        PRIMARY KEY (trip_id),

    CONSTRAINT fk_trips_rider
        FOREIGN KEY (rider_id)
        REFERENCES riders (rider_id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_trips_driver
        FOREIGN KEY (driver_id)
        REFERENCES drivers (driver_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_trips_fare
        CHECK (fare_amount >= 0)
);


-- -----------------------------------------------------------------
-- 5. driver_badge_awards
-- Junction table resolving the many-to-many relationship between
-- drivers and driver_badges.
-- The pair (driver_id, badge_id) forms the primary key, preventing
-- the same badge from being awarded to the same driver twice.
-- -----------------------------------------------------------------

CREATE TABLE driver_badge_awards (
    driver_id  INTEGER NOT NULL,
    badge_id   INTEGER NOT NULL,
    awarded_at TIMESTAMP NOT NULL,

    CONSTRAINT pk_driver_badge_awards
        PRIMARY KEY (driver_id, badge_id),

    CONSTRAINT fk_driver_badge_awards_driver
        FOREIGN KEY (driver_id)
        REFERENCES drivers (driver_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_driver_badge_awards_badge
        FOREIGN KEY (badge_id)
        REFERENCES driver_badges (badge_id)
        ON DELETE CASCADE
);