with
    aggregated as (
        {{ bigquery_datasets_publicly_accessible('cis_v1.2.0', '7.1') }}
        union
        {{ bigquery_datasets_without_default_cmek('cis_v1.2.0', '7.2') }}
        union
        {{ bigquery_tables_not_encrypted_with_cmek('cis_v1.2.0', '7.3') }}
    )
select *
from aggregated
