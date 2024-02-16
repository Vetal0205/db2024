CREATE SCHEMA db2024;
GRANT ALL ON ALL TABLES IN SCHEMA db2024 TO db2024_admin;

GRANT ALL ON ALL SEQUENCES IN SCHEMA db2024 TO db2024_admin;

GRANT SELECT ON ALL TABLES IN SCHEMA db2024 TO db2024_user;

GRANT SELECT ON ALL SEQUENCES IN SCHEMA db2024 TO db2024_user;

SET search_path TO db2024;

CREATE TABLE "hotels" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(255),
  "location" VARCHAR(255),
  "rating" DECIMAL(5,2)
);

CREATE TABLE "rooms" (
  "id" SERIAL PRIMARY KEY,
  "hotel_id" INTEGER,
  "type" VARCHAR(50),
  "price" DECIMAL(10,1),
  "available" BOOLEAN
);

CREATE TABLE "customers" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(255),
  "email" VARCHAR(255) UNIQUE,
  "phone" VARCHAR(50)
);

CREATE TABLE "bookings" (
  "id" SERIAL PRIMARY KEY,
  "customer_id" INTEGER,
  "room_id" INTEGER,
  "check_in_date" DATE,
  "check_out_date" DATE,
  "total_price" DECIMAL(10,1)
);

ALTER TABLE "rooms" ADD FOREIGN KEY ("hotel_id") REFERENCES "hotels" ("id");

ALTER TABLE "bookings" ADD FOREIGN KEY ("customer_id") REFERENCES "customers" ("id");

ALTER TABLE "bookings" ADD FOREIGN KEY ("room_id") REFERENCES "rooms" ("id");
