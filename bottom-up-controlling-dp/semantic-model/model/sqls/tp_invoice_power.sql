-- Source Aligned Data Product: tp_invoice_power
-- This represents the tpinvoicepower-dp data product

SELECT
    book,
    booking_month,
    country,
    cpty,
    customer,
    delivery_month,
    ent_inv,
    inv_amt,
    invoice_part,
    report_asof_date,
    segment,
    sub_segment,
    tnumgroup,
    vol_phys,
    zkey
FROM "icebase"."bottom_up"."tp_invoice_power" 