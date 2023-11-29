DROP TABLE IF EXISTS shipping_info;

CREATE TABLE shipping_info (
	shipping_id bigint,
	shipping_country_rate_id bigint,
	shipping_agreement_id bigint,
	shipping_transfer_id bigint,
	vendor_id bigint,
	shipping_plan_datetime timestamp,
	payment_amount numeric(14,2),
	constraint shipping_info_shipping_id_pkey PRIMARY KEY(shipping_id)
);

ALTER TABLE shipping_info 
  ADD CONSTRAINT shipping_info_shipping_country_rate_id_fkey FOREIGN KEY(shipping_country_rate_id)
REFERENCES shipping_country_rates(id) ON UPDATE CASCADE;

ALTER TABLE shipping_info 
  ADD CONSTRAINT shipping_info_shipping_agreement_id_fkey FOREIGN KEY(shipping_agreement_id)
REFERENCES shipping_agreement(agreement_id) ON UPDATE CASCADE;

ALTER TABLE shipping_info 
  ADD CONSTRAINT shipping_info_shipping_transfer_id_fkey FOREIGN KEY(shipping_transfer_id)
REFERENCES shipping_transfer(id) ON UPDATE CASCADE;

INSERT INTO shipping_info(shipping_id, shipping_country_rate_id, shipping_agreement_id, shipping_transfer_id,
			  vendor_id, shipping_plan_datetime, payment_amount)
WITH shipments AS ( 
SELECT DISTINCT s.shippingid
     , s.shipping_country
     , s.vendor_agreement_description
     , s.shipping_transfer_description
     , s.vendorid
     , s.shipping_plan_datetime
     , s.payment_amount
  FROM shipping s
),
shipments_arr AS (
SELECT s.shippingid
     , s.shipping_country
     , (regexp_split_to_array(s.vendor_agreement_description, ':+'))[1]::bigint AS shipping_agreement_id
     , regexp_split_to_array(s.shipping_transfer_description, ':+') AS shipping_transfer_description_arr
     , s.vendorid
     , s.shipping_plan_datetime
     , s.payment_amount
  FROM shipments s
)
SELECT s.shippingid
     , scr.id AS shipping_country_id
     , s.shipping_agreement_id
     , st.id AS shipping_transfer_id
     , s.vendorid
     , s.shipping_plan_datetime
     , s.payment_amount
  FROM shipments_arr s
  JOIN shipping_country_rates scr
    on scr.shipping_country = s.shipping_country
  JOIN shipping_transfer st
    ON st.transfer_type = s.shipping_transfer_description_arr[1]
   AND st.transfer_model = s.shipping_transfer_description_arr[2];

CREATE INDEX shipping_info_shipping_country_rate_id_ix
    ON shipping_info(shipping_country_rate_id); 

CREATE INDEX shipping_info_shipping_agreement_id_ix
    ON shipping_info(shipping_agreement_id);

CREATE INDEX shipping_info_shipping_transfer_id_ix
    ON shipping_info(shipping_transfer_id);

ANALYZE shipping_info;
