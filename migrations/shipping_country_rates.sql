DROP TABLE IF EXISTS shipping_country_rates;

CREATE TABLE shipping_country_rates (
    id bigserial,
    shipping_country text not null,
    shipping_country_base_rate numeric(14,3) not null,
    constraint shipping_country_rate_id_pkey primary key(id),
    constraint shipping_country_rate_shipping_country_ukey UNIQUE(shipping_country)
);

INSERT INTO shipping_country_rates(shipping_country, shipping_country_base_rate)
SELECT DISTINCT s.shipping_country
     , s.shipping_country_base_rate
  FROM shipping s;

ANALYZE shipping_country_rates;
