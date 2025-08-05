-- Bottom-up Controlling Data Model
-- This combines the consumer aligned data product (invoice_details_map_position) 
-- with the source aligned data product (tp_invoice_power) for comprehensive controlling analysis

SELECT 
    book,
    booking_month,
    contract_name,
    country,
    cpty,
    customer,
    delivery_month,
    ent_inv,
    installation_id,
    inv_amt,
    invoice_booking_date,
    invoice_is_cancellation,
    invoice_is_cancelled,
    invoice_number,
    invoice_part,
    invoice_type,
    metering_code,
    original_delivery_from,
    original_delivery_to,
    original_total_amount,
    original_total_volume_mwh,
    planned_end_date,
    planned_start_date,
    pod,
    report_asof_date,
    segment,
    split_amount,
    split_delivery_from,
    split_delivery_to,
    split_volume_mwh,
    sub_segment,
    table_name,
    tnum,
    tnumgroup,
    vol_phys,
    volume_unit,
    zkey
FROM (
    -- First part: Data from invoice_details_map_position (consumer aligned data product)
    SELECT 
        CAST(NULL AS TEXT) AS book,
        DATE(CAST(NULL AS TEXT)) AS booking_month,
        CAST(idmp.contract_name AS TEXT) AS contract_name,
        CAST(NULL AS TEXT) AS country,
        CAST(NULL AS TEXT) AS cpty,
        CAST(NULL AS TEXT) AS customer,
        DATE(CAST(NULL AS TEXT)) AS delivery_month,
        CAST(NULL AS TEXT) AS ent_inv,
        idmp.installation_id AS installation_id,
        CAST(CAST(NULL AS TEXT) AS DOUBLE PRECISION) AS inv_amt,
        idmp.invoice_booking_date AS invoice_booking_date,
        (CASE
            WHEN idmp.invoice_is_cancellation THEN 1
            WHEN NOT idmp.invoice_is_cancellation THEN 0
            ELSE NULL 
        END) AS invoice_is_cancellation,
        (CASE
            WHEN idmp.invoice_is_cancelled THEN 1
            WHEN NOT idmp.invoice_is_cancelled THEN 0
            ELSE NULL 
        END) AS invoice_is_cancelled,
        idmp.invoice_number AS invoice_number,
        CAST(NULL AS TEXT) AS invoice_part,
        idmp.invoice_type AS invoice_type,
        CAST(idmp.metering_code AS TEXT) AS metering_code,
        idmp.original_delivery_from AS original_delivery_from,
        idmp.original_delivery_to AS original_delivery_to,
        idmp.original_total_amount AS original_total_amount,
        idmp.original_total_volume_mwh AS original_total_volume_mwh,
        idmp.planned_end_date AS planned_end_date,
        idmp.planned_start_date AS planned_start_date,
        idmp.pod AS pod,
        DATE(CAST(NULL AS TEXT)) AS report_asof_date,
        CAST(NULL AS TEXT) AS segment,
        idmp.split_amount AS split_amount,
        idmp.split_delivery_from AS split_delivery_from,
        idmp.split_delivery_to AS split_delivery_to,
        idmp.split_volume_mwh AS split_volume_mwh,
        CAST(NULL AS TEXT) AS sub_segment,
        'invoice_details_map_position' AS table_name,
        CAST(idmp.tnum AS TEXT) AS tnum,
        CAST(NULL AS TEXT) AS tnumgroup,
        CAST(CAST(NULL AS TEXT) AS DOUBLE PRECISION) AS vol_phys,
        idmp.volume_unit AS volume_unit,
        CAST(TRUNC(CAST(CAST(NULL AS TEXT) AS DOUBLE PRECISION)) AS BIGINT) AS zkey
    FROM "bottom_up"."invoice_details_map_position" idmp
    
    UNION ALL
    
    -- Second part: Data from tp_invoice_power (source aligned data product)
    SELECT 
        CAST(tip.book AS TEXT) AS book,
        tip.booking_month AS booking_month,
        CAST(NULL AS TEXT) AS contract_name,
        CAST(tip.country AS TEXT) AS country,
        CAST(tip.cpty AS TEXT) AS cpty,
        CAST(tip.customer AS TEXT) AS customer,
        tip.delivery_month AS delivery_month,
        CAST(tip.ent_inv AS TEXT) AS ent_inv,
        CAST(NULL AS TEXT) AS installation_id,
        tip.inv_amt AS inv_amt,
        DATE(CAST(NULL AS TEXT)) AS invoice_booking_date,
        CAST(TRUNC(CAST(CAST(NULL AS TEXT) AS DOUBLE PRECISION)) AS BIGINT) AS invoice_is_cancellation,
        CAST(TRUNC(CAST(CAST(NULL AS TEXT) AS DOUBLE PRECISION)) AS BIGINT) AS invoice_is_cancelled,
        CAST(NULL AS TEXT) AS invoice_number,
        CAST(tip.invoice_part AS TEXT) AS invoice_part,
        CAST(NULL AS TEXT) AS invoice_type,
        CAST(NULL AS TEXT) AS metering_code,
        DATE(CAST(NULL AS TEXT)) AS original_delivery_from,
        DATE(CAST(NULL AS TEXT)) AS original_delivery_to,
        CAST(CAST(NULL AS TEXT) AS DOUBLE PRECISION) AS original_total_amount,
        CAST(CAST(NULL AS TEXT) AS DOUBLE PRECISION) AS original_total_volume_mwh,
        CAST(CAST(NULL AS TEXT) AS TIMESTAMP WITHOUT TIME ZONE) AS planned_end_date,
        CAST(CAST(NULL AS TEXT) AS TIMESTAMP WITHOUT TIME ZONE) AS planned_start_date,
        CAST(NULL AS TEXT) AS pod,
        tip.report_asof_date AS report_asof_date,
        CAST(tip.segment AS TEXT) AS segment,
        CAST(CAST(NULL AS TEXT) AS DOUBLE PRECISION) AS split_amount,
        DATE(CAST(NULL AS TEXT)) AS split_delivery_from,
        DATE(CAST(NULL AS TEXT)) AS split_delivery_to,
        CAST(CAST(NULL AS TEXT) AS DOUBLE PRECISION) AS split_volume_mwh,
        CAST(tip.sub_segment AS TEXT) AS sub_segment,
        'tp_invoice_power' AS table_name,
        CAST(NULL AS TEXT) AS tnum,
        CAST(tip.tnumgroup AS TEXT) AS tnumgroup,
        tip.vol_phys AS vol_phys,
        CAST(NULL AS TEXT) AS volume_unit,
        tip.zkey AS zkey
    FROM "bottom_up"."tp_invoice_power" tip
) combined_data 