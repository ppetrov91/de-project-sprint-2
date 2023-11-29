DROP TABLE IF EXISTS shipping_status;

CREATE TABLE shipping_status (
    shipping_id bigint,
    shipping_start_fact_datetime timestamp,
    shipping_end_fact_datetime timestamp,
    status text,
    state text,
    constraint shipping_status_shipping_id_pkey PRIMARY KEY(shipping_id)
);

ALTER TABLE shipping_status
  ADD CONSTRAINT shipping_status_shipping_id_fkey FOREIGN KEY (shipping_id)
  REFERENCES shipping_info(shipping_id);

INSERT INTO shipping_status(shipping_id, shipping_start_fact_datetime, 
	                    shipping_end_fact_datetime, status, state)
WITH ds AS (
SELECT s.shippingid
     , MAX(s.state_datetime) FILTER(WHERE s.state = 'booked') AS shipping_start_fact_datetime
     , MAX(s.state_datetime) FILTER(WHERE s.state = 'recieved') AS shipping_end_fact_datetime
     , MAX(s.state_datetime) AS last_log_date
  FROM shipping s
 GROUP BY s.shippingid
)
SELECT d.shippingid
     , d.shipping_start_fact_datetime
     , d.shipping_end_fact_datetime
     , s.status
     , s.state
  FROM ds d
  JOIN shipping s
    ON s.shippingid = d.shippingid
   AND s.state_datetime = d.last_log_date;

ANALYZE shipping_status;
