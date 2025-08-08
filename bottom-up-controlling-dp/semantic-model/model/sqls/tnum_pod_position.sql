-- Source Aligned Data Product: tnum_pod_position
-- This represents the tnumpodposition-dp data product

SELECT
    metering_code,
    planned_start_date,
    planned_end_date,
    tnum,
    contract_name
FROM "icebase"."bottomup"."tnum_pod_position"