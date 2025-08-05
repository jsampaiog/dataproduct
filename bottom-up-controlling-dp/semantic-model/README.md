# Consumer Aligned Data Product - Practice Impact Solutions

## Overview

This semantic model defines consumer aligned data products that combine multiple source aligned data products to provide comprehensive invoice, position, and controlling analysis capabilities.

## Data Product Architecture

### Source Aligned Data Products (Inputs)

The consumer aligned data products are built upon the following source aligned data products:

1. **monthlyrevenue-dp** (`monthly_revenue`)
   - Contains invoice details and revenue data
   - Key fields: installation_id, invoice details, amounts, volumes, delivery dates
   - Schema: `bottom_up.monthly_revenue`

2. **diminstallationlast-dp** (`dim_installation_last`)
   - Contains installation dimension data
   - Key fields: installation_id, installation_last_ext_pod_id
   - Schema: `bottom_up.dim_installation_last`

3. **tnumpodposition-dp** (`tnum_pod_position`)
   - Contains transaction number and POD position data
   - Key fields: metering_code, planned dates, tnum, contract_name
   - Schema: `bottom_up.tnum_pod_position`

4. **tpinvoicepower-dp** (`tp_invoice_power`)
   - Contains invoice power data
   - Key fields: book, customer, amounts, volumes, segments
   - Schema: `bottom_up.tp_invoice_power`

### Consumer Aligned Data Products (Outputs)

#### 1. **invoice_details_map_position** - Primary Consumer Aligned Data Product
Combines source data products to provide:
- Complete invoice details with installation mapping
- Position and contract information
- Revenue and volume analysis capabilities
- Temporal analysis with booking and delivery dates

#### 2. **bottom_up_controlling** - Comprehensive Controlling Data Model
Combines the consumer aligned data product with additional source data for:
- Complete controlling analysis across all data sources
- Unified view of invoice details and power data
- Data lineage tracking with table_name field
- Comprehensive business intelligence capabilities

## Data Flow

```
Source Aligned Data Products:
monthly_revenue (monthlyrevenue-dp)
    ↓
    ├── LEFT JOIN dim_installation_last (diminstallationlast-dp)
    │   └── ON installation_id
    │
    └── LEFT JOIN tnum_pod_position (tnumpodposition-dp)
        └── ON metering_code = installation_last_ext_pod_id
        └── AND split_delivery_from BETWEEN planned_start_date AND planned_end_date
        ↓
        invoice_details_map_position (Consumer Aligned Data Product)
            ↓
            UNION ALL
            ↓
            tp_invoice_power (tpinvoicepower-dp)
                ↓
                bottom_up_controlling (Comprehensive Controlling Data Model)
```

## Key Business Logic

### invoice_details_map_position
1. **Installation Mapping**: Links invoice data to installation details via installation_id
2. **Position Mapping**: Maps installations to positions using metering codes
3. **Temporal Filtering**: Ensures position data is valid for the delivery period
4. **Contract Association**: Links transactions to contract information

### bottom_up_controlling
1. **Data Consolidation**: Combines invoice details mapping with invoice power data
2. **Data Lineage**: Tracks source table for each record via table_name field
3. **Unified Schema**: Provides consistent field structure across all data sources
4. **Comprehensive Analysis**: Enables cross-source business intelligence

## Available Metrics

### invoice_details_map_position

#### Dimensions
- Transaction identifiers (tnum, zkey)
- Temporal data (invoice_booking_date, planned dates, delivery dates)
- Business entities (contract_name)
- Technical identifiers (installation_id, pod, metering_code)

#### Measures
- **inv_amt**: Total invoice amount
- **original_total_amount**: Total original amount
- **split_amount**: Split amount
- **original_total_volume_mwh**: Total original volume in MWh
- **split_volume_mwh**: Split volume in MWh
- **count**: Record count

### bottom_up_controlling

#### Dimensions
- Transaction identifiers (book, tnum, tnumgroup, zkey)
- Temporal data (booking_month, delivery_month, invoice_booking_date, planned dates)
- Business entities (customer, contract_name, country, cpty)
- Technical identifiers (installation_id, pod, metering_code)
- Business segments (segment, sub_segment)
- Data lineage (table_name)

#### Measures
- **inv_amt**: Total invoice amount
- **original_total_amount**: Total original amount
- **split_amount**: Split amount
- **original_total_volume_mwh**: Total original volume in MWh
- **split_volume_mwh**: Split volume in MWh
- **vol_phys**: Physical volume
- **count**: Record count

#### Segments
- **invoice_details_mapping_records**: Records from invoice_details_map_position
- **invoice_power_records**: Records from tp_invoice_power
- **cancelled_invoices**: Filter for cancelled invoices
- **cancellation_invoices**: Filter for cancellation invoices
- **active_contracts**: Filter for active contracts
- **has_installation_data**: Records with installation information
- **has_contract_data**: Records with contract information

## Usage

### invoice_details_map_position
Used for:
1. **Revenue Analysis**: Track invoice amounts and volumes across different dimensions
2. **Contract Performance**: Analyze contract execution and delivery performance
3. **Installation Analytics**: Monitor installation-level metrics and trends
4. **Temporal Analysis**: Study patterns across booking and delivery periods

### bottom_up_controlling
Used for:
1. **Comprehensive Controlling**: Unified analysis across all data sources
2. **Data Lineage Analysis**: Track data origins and transformations
3. **Cross-Source Reporting**: Generate reports that span multiple data products
4. **Business Intelligence**: Advanced analytics and dashboard creation
5. **Data Quality Monitoring**: Identify gaps and inconsistencies across sources

## Data Quality

The models include data quality considerations:
- Proper handling of NULL values in joins and unions
- Boolean flag management for cancellation status
- Temporal validation for position data
- Consistent data type casting across sources
- Data lineage tracking for audit and compliance

## Dependencies

### invoice_details_map_position depends on:
- monthlyrevenue-dp
- diminstallationlast-dp
- tnumpodposition-dp

### bottom_up_controlling depends on:
- invoice_details_map_position (consumer aligned data product)
- tpinvoicepower-dp

All source data products must be available in the `bottom_up` schema for the consumer aligned data products to function correctly. 