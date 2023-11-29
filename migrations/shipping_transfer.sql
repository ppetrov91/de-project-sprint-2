DROP TABLE IF EXISTS shipping_transfer CASCADE;

CREATE TABLE shipping_transfer (
    id bigserial,
    transfer_type char(2) not null check (transfer_type in ('1p', '3p')),
    transfer_model text not null check (transfer_model in ('car', 'train', 'ship', 'airplane', 'multiplie')),
    shipping_transfer_rate NUMERIC(14,3) not null,
    constraint shipping_transfer_id_pkey primary key(id)
);

INSERT INTO shipping_transfer(transfer_type, transfer_model, shipping_transfer_rate)
SELECT s.shipping_transfer_description_arr[1]::char(2) AS transfer_type
     , s.shipping_transfer_description_arr[2] AS transfer_model
     , s.shipping_transfer_rate
  FROM (SELECT regexp_split_to_array(s.shipping_transfer_description, ':+') AS shipping_transfer_description_arr
	     , s.shipping_transfer_rate
  	  FROM (SELECT DISTINCT s.shipping_transfer_description
     		     , s.shipping_transfer_rate
  		  FROM shipping s
  	       ) s
       ) s;

ANALYZE shipping_transfer;
