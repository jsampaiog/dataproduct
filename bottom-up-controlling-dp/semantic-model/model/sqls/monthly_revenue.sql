-- Source Aligned Data Product: monthly_revenue
-- This represents the monthlyrevenue-dp data product

SELECT
    installation_id,
    invoice_booking_date,
    invoice_is_cancellation,
    invoice_is_cancelled,
    invoice_number,
    invoice_type,
    original_delivery_from,
    original_delivery_to,
    original_total_amount,
    original_total_volume_mwh,
    split_amount,
    split_delivery_from,
    split_delivery_to,
    split_volume_mwh,
    volume_unit
FROM "icebase"."bottom_up"."monthly_revenue" 