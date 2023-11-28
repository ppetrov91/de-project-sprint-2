DROP TABLE IF EXISTS shipping_agreement;

CREATE TABLE shipping_agreement (
	agreement_id bigint,
	agreement_number text not null,
	agreement_rate NUMERIC(14,3) not null,
	agreement_commission NUMERIC(14,3) not null,
	constraint shipping_agreement_agreement_id_pkey primary key(agreement_id)
);

INSERT INTO shipping_agreement(agreement_id, agreement_number, agreement_rate, agreement_commission)
SELECT (s.vendor_agr_descr_arr[1])::bigint AS agreement_id
	 , s.vendor_agr_descr_arr[2] AS agreement_number
	 , (s.vendor_agr_descr_arr[3])::numeric(14,3) AS agreement_rate
	 , (s.vendor_agr_descr_arr[4])::numeric(14,3) AS agreement_commission
  FROM (SELECT regexp_split_to_array(s.vendor_agreement_description, ':+') AS vendor_agr_descr_arr
          FROM (SELECT DISTINCT s.vendor_agreement_description
                  FROM shipping s
               ) s
       ) s;

ANALYZE shipping_agreement;