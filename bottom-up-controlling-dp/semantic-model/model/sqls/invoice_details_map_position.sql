-- Consumer Aligned Data Product: invoice_details_map_position
-- This combines data from the source aligned data products:
-- - monthlyrevenue-dp (as monthly_revenue)
-- - diminstallationlast-dp (as dim_installation_last)
-- - tnumpodposition-dp (as tnum_pod_position)

SELECT
    fid.*,
    dil.installation_last_ext_pod_id AS POD,
    tpp.planned_start_date,
    tpp.planned_end_date,
    tpp.metering_code,
    tpp.tnum,
    tpp.contract_name
FROM "icebase"."bottom_up"."monthly_revenue" fid 
LEFT JOIN "icebase"."bottom_up"."dim_installation_last" dil ON fid.installation_id = dil.installation_id 
LEFT JOIN "icebase"."bottom_up"."tnum_pod_position" tpp ON (
    tpp.metering_code = dil.installation_last_ext_pod_id
) 
AND (fid.split_delivery_from BETWEEN tpp.planned_start_date AND tpp.planned_end_date) 