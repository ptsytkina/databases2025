-- stage 
CREATE OR REPLACE TABLE HM_2.stg_orders AS
SELECT * FROM HM_2.orders;

CREATE OR REPLACE TABLE HM_2.stg_establishment AS
SELECT * FROM HM_2.establishments;

CREATE OR REPLACE TABLE HM_2.stg_payments AS
SELECT * FROM HM_2.payments;

CREATE OR REPLACE TABLE HM_2.stg_clients AS
SELECT * FROM HM_2.clients;

CREATE OR REPLACE TABLE HM_2.stg_couriers AS
SELECT * FROM HM_2.couriers;


-- mart
CREATE OR REPLACE TABLE HM_2.fct_orders AS
SELECT
  o.order_id,
  o.client_id,
  o.courier_id,
  o.establishment_id,
FROM HM_2.stg_orders o
JOIN HM_2.stg_payments p
  ON o.order_id = p.order_id;


CREATE OR REPLACE TABLE HM_2.dim_order AS
SELECT
  o.order_id,
  o.`start point`,
  o.`end point`,
  o.`start time`,
  o.`end time`,
  p.payment_type AS payment_type,
  p.cost_amount AS payment_amount,
  c.name AS client_name,
  c.`phone number` AS client_number,
  c.gmail AS client_gmail,
FROM HM_2.stg_orders o
JOIN HM_2.stg_payments p ON o.order_id = p.order_id
JOIN HM_2.fct_orders f ON o.order_id = f.order_id
JOIN HM_2.stg_clients c ON f.client_id = c.client_id;
-- stage 
CREATE OR REPLACE TABLE HM_2.stg_orders AS
SELECT * FROM HM_2.orders;

CREATE OR REPLACE TABLE HM_2.stg_establishment AS
SELECT * FROM HM_2.establishments;

CREATE OR REPLACE TABLE HM_2.stg_payments AS
SELECT * FROM HM_2.payments;

CREATE OR REPLACE TABLE HM_2.stg_clients AS
SELECT * FROM HM_2.clients;

CREATE OR REPLACE TABLE HM_2.stg_couriers AS
SELECT * FROM HM_2.couriers;


-- mart
CREATE OR REPLACE TABLE HM_2.fct_orders AS
SELECT
  o.order_id,
  o.client_id,
  o.courier_id,
  o.establishment_id,
FROM HM_2.stg_orders o
JOIN HM_2.stg_payments p
  ON o.order_id = p.order_id;


CREATE OR REPLACE TABLE HM_2.dim_order AS
SELECT
  o.order_id,
  o.`start point`,
  o.`end point`,
  o.`start time`,
  o.`end time`,
  p.payment_type AS payment_type,
  p.cost_amount AS payment_amount,
  c.name AS client_name,
  c.`phone number` AS client_number,
  c.gmail AS client_gmail,
FROM HM_2.stg_orders o
JOIN HM_2.stg_payments p ON o.order_id = p.order_id
JOIN HM_2.fct_orders f ON o.order_id = f.order_id
JOIN HM_2.stg_clients c ON f.client_id = c.client_id;


CREATE OR REPLACE TABLE HM_2.dim_establishment AS
SELECT DISTINCT
    e.establishmen_id,
    e.adress,
    e.rating,
    e.category,
    o.order_id,
    o.`start point`,
    o.`end point`,
    o.`start time`,
    o.`end time`,
    p.payment_type AS payment_type,
    p.cost_amount AS payment_amount
FROM HM_2.stg_orders o
JOIN HM_2.stg_establishment e ON o.establishment_id = e.establishmen_id
JOIN HM_2.stg_payments p ON o.order_id = p.order_id;


CREATE OR REPLACE TABLE `HM_2.dim_client` AS
SELECT DISTINCT
    e.establishmen_id,
    e.adress,
    e.rating,
    e.category,
    c.name AS client_name,
    c.`phone number` AS client_number,
    c.gmail AS client_gmail,
    p.payment_type AS payment_type,
    p.cost_amount AS payment_amount
FROM HM_2.stg_clients c
JOIN HM_2.fct_orders f ON c.client_id = f.client_id
JOIN HM_2.stg_establishment e ON f.establishment_id = e.establishmen_id
JOIN HM_2.stg_payments p ON f.order_id = p.order_id;

CREATE OR REPLACE TABLE HM_2.dim_courier AS
SELECT DISTINCT
    o.order_id,
    o.`start point`,
    o.`end point`,
    o.`start time`,
    o.`end time`,
    cur.courier_id,
    cur.name AS courier_name,
    cur.`phone number` AS courier_number,
    cur.rating AS courier_rating,
    cur.type_vehicle AS type_vehicle
FROM HM_2.orders o
JOIN HM_2.stg_couriers cur ON o.courier_id = cur.courier_id;


--bonus
CREATE TABLE IF NOT EXISTS HM_2.dim_client_scd2(
  client_key STRING DEFAULT GENERATE_UUID(),
  client_id    INT64,     
  name         STRING,
  phone        STRING,
  email        STRING,
  valid_from   DATE,
  valid_to     DATE,
  is_current   BOOL
);

INSERT INTO HM_2.dim_client_scd2 (
  client_id,
  name,
  phone,
  email,
  valid_from,
  valid_to,
  is_current
)
SELECT
  client_id,
  name,
  `phone number`,
  gmail,
  CURRENT_DATE()          AS valid_from,
  DATE '2100-12-31'       AS valid_to,
  TRUE                    AS is_current
FROM HM_2.stg_clients;

UPDATE HM_2.dim_client_scd2 AS d
SET
  valid_to   = CURRENT_DATE(),
  is_current = FALSE
FROM HM_2.stg_clients AS r
WHERE d.client_id = r.client_id
  AND d.is_current = TRUE
  AND (
       d.name  != r.name
    OR d.phone != r.`phone number`
    OR d.email != r.gmail
  );

INSERT INTO HM_2.dim_client_scd2 (
  client_id,
  name,
  phone,
  email,
  valid_from,
  valid_to,
  is_current
)
SELECT
  r.client_id,
  r.name,
  r.`phone number`,
  r.gmail,
  CURRENT_DATE()    AS valid_from,
  DATE '2100-12-31' AS valid_to,
  TRUE              AS is_current
FROM HM_2.stg_clients AS r
JOIN HM_2.dim_client_scd2 AS d
  ON r.client_id = d.client_id
WHERE d.valid_to = CURRENT_DATE()
  AND d.is_current = FALSE;
