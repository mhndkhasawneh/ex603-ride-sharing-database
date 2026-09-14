# ex603-ride-sharing-database

## Mohannad Khasawneh 
Ride Sharing Database

A relational database design for a ride-sharing platform that connects riders with drivers and records trips, fares, and driver badges.

### Theme

Ride Sharing

The database is organized around five main roles:

* Actor: Riders
* Producer: Drivers
* Event: Trips
* Catalog: Driver Badges
* Junction: Driver Badge Awards
* Metric: Fare Amount

### Domain

This project models the relational database for a ride-sharing platform that connects riders with drivers. Riders use the platform to take trips, while drivers provide transportation services. Each trip records the rider and driver involved, when the trip occurred, and the fare charged. The platform also maintains information about whether drivers are active and includes a numeric driver attribute that can be used for filtering and analysis.

The database also tracks badges that can be awarded to drivers. A driver may earn multiple badges, and the same badge may be awarded to many different drivers. The system should be able to answer questions such as which rider and driver were involved in a trip, how much a trip cost, how many trips a driver completed, how much fare revenue a driver generated, which drivers are currently active, and which badges have been awarded to each driver.

### Entity Relationship Diagram

The Entity Relationship Diagram (ERD) represents the five relations in the ride-sharing database and the relationships between them.

![Ride Sharing Database ERD](schema/erd.png)